class BalanceCalculator

  def initialize(user)
    @user = user
  end

  def forecast_balance(to)
    balance_forecasts = []
    balance = @user.balance
    # get all transfer dates occurring after the user's latest balance update
    from = balance.on.to_date + 1.day
    transfer_dates = transfer_calculator.all_transfer_dates(from, to)
    balance = balance.value

    transfer_dates.each do |transfer_date|
      transfers = transfer_calculator.transfers_occurring_on transfer_date
      diff = TransferCalculator.total_difference transfers
      balance+= diff
      balance_forecasts << BalanceForecast.new(transfer_date, balance, transfers)
    end
    balance_forecasts
  end

  def forecast_balance_between(start_date, end_date)
    forecast_balance(end_date).reject { |forecast| forecast.date < start_date }
  end

  def balance_log(from = nil, to)
    from ||= @user.balances.first
    balance_dates = @user.balances.all
      .select { |balance| balance.on >= from && balance.on <= to }
      .map { |balance| balance.on.to_date }
      .uniq
    balance_dates.map { |balance_date| last_balance_of_day balance_date }
  end

  def month_diff(date)
    # - 1 day here so we can get the last balance from the previous month
    # diff = last of this month - last of last month
    previous_balance = balance_on(date.beginning_of_month - 1.day)
    bals = previous_balance.present? ? [previous_balance] : []
    bals += @user.balances.all.select { |b| b.on >= date.beginning_of_month && b.on <= date.end_of_month }
    bals.sort_by!(&:on)
    bals.last.value - bals.first.value
  end

  # Public: returns the balance on a particular date
  #
  # Goes backwards from this date until a balance is found- this is the balance for this date
  # returns the balance
  def balance_on(date)
    @user.balances.all.select { |balance| balance.on.to_date <= date }
      .sort_by { |balance| balance.on }
      .last
  end

  private

  def transfer_calculator
    @transfer_calculator ||= TransferCalculator.new(@user)
  end

  def last_balance_of_day date
    balances = @user.balances.all.select { |balance| balance.on.to_date == date }
    balances.sort_by { |balance| balance.on }.last
  end
end
