class NumberCruncher

  # Get a balance forecast for this user
  #
  # Predicts future bank balances based on the incomings/outgoings
  # returns an array FinanceItems
  def self.finance_forecast user
    trans = user.transfers.order(:on)
    return [] unless trans.any?
    from = trans.first.on.to_date
    to = trans.last.on.to_date+1.year
    balance_forecast_between(from, to, user).sort_by(&:on)
  end

  # Get a log of balances for this user
  #
  # Returns an array of FinanceItems based on the user's logged balances
  def self.finance_log user
    bals = user.balances.order(:on)
    return [] unless bals.any?
    from = bals.first.on
    to = bals.last.on
    finance_log_between(from, to, user).sort_by(&:on)
  end

private

  # Calculates the predicted balances over time
  #
  # Returns an array of FinanceItems
  def self.calculate_balance_forecast date_to_transfers, latest_balance
    # let us only consider transfers that occur after the last balance update
    date_to_transfers = date_to_transfers.select { |day, _| day > latest_balance.on }.sort
    monthly_transfers = trans_per_month date_to_transfers
    balance_value = latest_balance.value
    forecast = []
    date_to_transfers.each do |day, tra|
      # sum all outgoing transfers
      out_vals = Transfer.sum_outgoing tra
      # sum all incoming transfers
      in_vals = Transfer.sum_incoming tra

      total = -out_vals + in_vals

      balance_value += total
      month_diff = nil
      last_date_trans_of_mon = monthly_transfers[day.beginning_of_month].sort_by { |day, _| day }
      last_date = last_date_trans_of_mon.last[0]
      last_transfers = last_date_trans_of_mon.map { |_, dat_tran| dat_tran }.flatten

      if day == last_date
        incomings = Transfer.sum_incoming last_transfers
        outgoings = Transfer.sum_outgoing last_transfers
        month_diff = incomings - outgoings
      end

      forecast << FinanceItem.new(day, balance_value, total, month_diff)
    end
    forecast
  end

  # Group transfers by the day they will take place on
  # A transfer can be registered once, but may have a recurrence that means it will occur repeatedly (every mnonth say)
  #
  # Returns a hash mappping dates to the transfers that occur
  def self.group_transfers_by_date transfers, start_date, end_date
    return {} unless transfers.any? && end_date >= start_date

    date_to_transfers = {}

    transfers.each do |trans|
      on = trans.on.to_date
      recurrence = trans.recurrence.to_sym
      if recurrence == :no && (on >= start_date && on <= end_date)
        (date_to_transfers[on]||=[]) << trans
      elsif recurrence == :daily && on <= end_date
        ((end_date - on).to_i + 1).times do |day_to_add|
          (date_to_transfers[on + day_to_add.days]||=[]) << trans
        end
      elsif recurrence == :weekly && on <= end_date
        (((end_date - on) / 7).to_i + 1).times do |wk|
          (date_to_transfers[on + wk.weeks]||=[]) << trans
        end
      elsif recurrence == :monthly && on <= end_date
        ((on.months_between(end_date)).to_i + 1).times do |mt|
          (date_to_transfers[on + mt.months]||=[]) << trans
        end
      end
    end
    date_to_transfers
  end

  # Group a date_to_transfer hash by the month the transfers take place
  # e.g. {month1 => {date1 => [trans1, trans2], date2 => [trans2, trans3]}, month2 => {date1 => [trans1]}, ...}
  def self.trans_per_month date_to_transfers
    date_to_transfers.group_by do |date, _|
      date.beginning_of_month
    end
  end

  # creates a list of FinanceItems based on calculations from saved transfers
  def self.balance_forecast_between(start_date, end_date, user)
    # get a hash that maps dates to an array of transfers, {date1 => [transfer, transfer], date2 => [transfer, transfer]}
    date_to_transfers = group_transfers_by_date user.transfers, start_date, end_date
    calculate_balance_forecast date_to_transfers, user.balance
  end

  # creates a list of FinanceItems based on *saved* balance updates
  # Note: This does not take into account balance predictions
  #
  def self.finance_log_between(start_date, end_date, user)
    # pointless going any further if there are no balance updates associated with this user
    return [] if !user.balances.any? || end_date < start_date

    relevant_balances = user.balances.select { |b| b.on.between? start_date, end_date }
    # no balances for these dates
    return [] unless relevant_balances.any?

    log = []
    balance_groups = relevant_balances.group_by { |bal| bal.on.day_s }
    balance_groups.each do |day, bals|
      bals = bals.sort_by { |bal| bal.on }
      bal = bals.last
      on = bal.on
      month_diff = bals.last.last_of_month? ? bals.last.month_diff : nil
      log << FinanceItem.new(on, bal.value, bal.diff_from_previous_day, month_diff)
    end
    log
  end
end
