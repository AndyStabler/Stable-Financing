class User < ActiveRecord::Base

  extend FriendlyId

  friendly_id :username

  has_many :transfers
  # many balances over time - store them so the user can see what's going on
  has_many :balances
  validates_format_of :username, :with => /\A[a-z0-9]+\z/i

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

  def trans_per_month trans_date_map
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
    # the last balance
    bal = balances.order(:on).last

    # get a map from date to array of transfers, [date1 => [transfer, transfer], date2 => [transfer, transfer]]
    trans_date_hash = calculate_transfers_between start_date, end_date
    # order the elements by the date they occur
    trans_date_hash = trans_date_hash.sort_by { |day, _| day }
    # let us only consider transfers that occur after the last balance update
    trans_date_hash = trans_date_hash.select { |day, _| day >= bal.on }

    create_prediction_finance_rows trans_date_hash
  end

  def calculate_transfers_between start_date, end_date
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
    trans_date_map
  end

  def create_prediction_finance_rows date_trans
    latest_balance = balances.order(:on).last
    date_trans = date_trans.select { |day, _| day > latest_balance.on }
    monthly_transfers = trans_per_month(date_trans)
    balance_value = latest_balance.value
    rows = Array.new
    date_trans.each do |day, tra|

      out_vals = tra.select { |tr| tr.outgoing }.map do |tr|
        tr.amount
      end.inject(:+)
      in_vals = tra.select { |tr| !tr.outgoing }.map do |tr|
        tr.amount
      end.inject(:+)
      total = -(out_vals||0) + (in_vals||0)

      balance_value += total
      month_diff = nil
      last_date_trans_of_mon = monthly_transfers[day.beginning_of_month].sort_by { |day, _| day }
      last_date = last_date_trans_of_mon.last[0]
      last_transfers = last_date_trans_of_mon.map { |_, dat_tran| dat_tran }.flatten

      if day == last_date
        incomings = last_transfers.select { |trans| !trans.outgoing }.map(&:amount).inject(:+).to_f
        outgoings = last_transfers.select { |trans| trans.outgoing }.map(&:amount).inject(:+).to_f
        month_diff = incomings - outgoings
      end

      rows << FinanceRow.new(day.day_s, balance_value, total, month_diff)
    end
    rows
  end

  def all_prediction_data
    trans = transfers.order(:on)
    return [] unless trans.any?
    from = trans.first.on
    to = trans.last.on+1.year
    prediction_data_between(from, to)
  end

  def balance
    balances.order(:on).last
  end
  end

end