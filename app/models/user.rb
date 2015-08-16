class User < ActiveRecord::Base

  has_many :transfers
  # many balances over time - store them so the user can see what's going on
  has_many :balances

  def incoming
    transfers.where(outgoing: false)
  end

  def outgoing
    transfers.where(outgoing: true)
  end

  def finance_rows
    bal_data = all_balance_data
    pred_data = all_prediction_data
    bal_data.concat(pred_data)
  end

  ##
  # creates a list of FinanceRows based on saved balance updates
  #
  def balance_data_between(start_date, end_date)
    # pointless going any further if there are no balance updates associated with this user
    return [] unless balances.any? || end_date < start_date

    relevant_balances = balances.where(on: start_date..end_date+1)
    # no balances for these dates
    return [] unless relevant_balances.any?

    rows = Array.new
    balance_groups = relevant_balances.group_by { |bal| bal.on.day_s }
    balance_groups.each do |day, bals|
      row_on = bals.last.on.day_s
      row_bal = bals.sort_by { |bal| bal[:on] }.last
      row_month_diff = bals.last.last_of_month? ? bals.last.month_diff : nil
      rows << FinanceRow.new(row_on, row_bal.value, row_bal.diff_from_previous_balance, row_month_diff)
    end
    rows
  end

  def month_diffs trans_date_map
    trans_date_map.group_by do |date, _|
      date.beginning_of_month
    end

  end

  def all_balance_data
    bals = balances.order(:on)

    return [] unless bals.any?
    from = bals.first.on
    to = bals.last.on
    balance_data_between(from, to)
  end

  ##
  # creates a list of FinanceRows based on calculations from saved transfers
  #
  def prediction_data_between(start_date, end_date)
    return [] unless transfers.any? && balances.any? && end_date > start_date
    # map from date
    trans_date_map = Hash.new

    transfers.each do |trans|
      sym = trans.recurrence.to_sym
      if sym == :no && (trans.on >= start_date && trans.on <= end_date)
        (trans_date_map[trans.on]||=Array.new) << trans
      elsif sym == :daily && trans.on <= end_date
        (end_date.to_date - trans.on.to_date).to_i.times do |day_to_add|
          (trans_date_map[trans.on + day_to_add.days]||=Array.new)<< trans
        end
      elsif sym == :weekly && trans.on <= end_date
        ((end_date.to_date - trans.on.to_date) / 7).floor.to_i.times do |wk|
          (trans_date_map[trans.on + wk.weeks]||=Array.new) <<trans
        end
      elsif sym == :monthly && trans.on <=end_date
        (trans.on.months_between(end_date)).to_i.times do |mt|

          (trans_date_map[trans.on + mt.months]||=Array.new) << trans
        end
      end
    end

    # [date => [transfers]]
    rows = Array.new

    # month diffs
    # month_diffs = trans_date_map.group_by { |dat, trans| dat.beginning_of_month }
    # a map from each month to a map from date to an array of transfers

    # logger.debug "month_diffs is #{month_diffs.keys}"

    # the last balance
    bal = balances.order(:on).last
    diffs = month_diffs(trans_date_map.sort_by { |k, _| k }.select { |dte, _| dte >= bal.on }) #.select{|key,_| key >= DateTime.now}
    new_bal = bal.value
    trans_date_map.sort_by { |k, _| k }.select { |dte, _| dte >= bal.on }.each do |day, tra|
      #logger.debug "date is #{day}, trans array is #{trans}"

      #logger.debug "out_vals e . ."
      out_vals = tra.select { |tr| tr.outgoing }.map do |tr|
        #logger.debug "tr.amount is #{tr.amount}"
        tr.amount
      end.inject(:+)
      #logger.debug "in_vals . . ."
      in_vals = tra.select { |tr| !tr.outgoing }.map do |tr|
        #logger.debug "tr.amount is #{tr.amount}"
        tr.amount
      end.inject(:+)
      #logger.debug "out_vals is #{out_vals}, in_vals is #{in_vals}"
      total = -(out_vals||0) + (in_vals||0)

      # transfer_sum_on_day = trans.select { |tr| tr.outgoing }.map { |tr| tr.amount }.inject(:-).to_f + (trans.select { |tr| !tr.outgoing }.map { |tr| tr.amount }.inject(:+))
      new_bal += total #transfer_sum_on_day
      month_diff = nil
      #logger.debug "diffs is #{diffs}"
      # TODO: what's going on here? We were using a hash map, now it's turned into an array? Are they the same?
      rel_tr = diffs[day.beginning_of_month].last[1].sort_by { |tr| tr.on }
      logger.debug "relevant transactions is #{rel_tr}"
      logger.debug "checking if day #{day} == #{rel_tr.last.on}"
      # if this date is the last for the month
      # [month => [date => [trans1, trans1], date => [trans1, trans2],
      #  month => [date => [trans1, trans1], date => [trans1, trans2]]
      if day == rel_tr.last.on
        # get all [date => [trans]] for this month, then sum the
        valid_trans = rel_tr #diffs[tr.on.beginning_of_month].values
        incomings = valid_trans.select { |trans| !trans.outgoing }.flatten.map(&:amount).inject(:+).to_f
        outgoings = valid_trans.select(&:outgoing).flatten.map(&:amount).inject(:+).to_f

        month_diff = incomings - outgoings
      end

      rows << FinanceRow.new(day.day_s, new_bal, total, month_diff)
    end

    return rows
  end

  def calculate_transfers_between start_date, end_date

  end

  def all_prediction_data
    trans = transfers.order(:on)
    return [] unless trans.any?
    #logger.debug "first transfer is #{trans.first}"
    from = trans.first.on
    to = trans.last.on+1.year
    prediction_data_between(from, to)
  end

end