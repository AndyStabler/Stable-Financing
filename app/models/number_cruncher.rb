class NumberCruncher

  def initialize user
    @user = user
  end

  # Calculates the predicted balances over time
  #
  # Returns an array of FinanceItems
  def calculate_balance_forecast date_to_transfers
    # let us only consider transfers that occur after the last balance update
    date_to_transfers = date_to_transfers.select { |day, _| day > @user.balance.on }.sort
    monthly_transfers = trans_per_month date_to_transfers
    balance_value = @user.balance.value
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

  # Group a date_to_transfer hash by the month the transfers take place
  # e.g. {month1 => {date1 => [trans1, trans2], date2 => [trans2, trans3]}, month2 => {date1 => [trans1]}, ...}
  def trans_per_month date_to_transfers
    date_to_transfers.group_by do |date, _|
      date.beginning_of_month
    end
  end

  # creates a list of FinanceItems based on calculations from saved transfers
  def balance_forecast_between(start_date, end_date)
    # get a hash that maps dates to an array of transfers, {date1 => [transfer, transfer], date2 => [transfer, transfer]}
    date_to_transfers = Transfer.group_transfers_by_date @user.transfers, start_date, end_date
    calculate_balance_forecast date_to_transfers
  end

  # creates a list of FinanceItems based on *saved* balance updates
  # Note: This does not take into account balance predictions
  #
  def finance_log_between(start_date, end_date)
    # pointless going any further if there are no balance updates associated with this user
    return [] if !@user.balances.any? || end_date < start_date

    relevant_balances = @user.balances.select { |b| b.on.between? start_date, end_date }
    # no balances for these dates
    return [] unless relevant_balances.any?

    log = []
    balance_groups = relevant_balances.group_by { |bal| bal.on.day_s }
    balance_groups.each do |day, bals|
      bals = bals.sort_by { |bal| bal.on }
      bal = bals.last
      on = bal.on
      month_diff = bal.last_of_month? ? bal.month_diff : nil
      log << FinanceItem.new(on, bal.value, bal.diff_from_previous_day, month_diff)
    end
    log
  end
end
