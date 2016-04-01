class BalanceForecaster

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

  private

  def transfer_calculator
    @transfer_calculator ||= TransferCalculator.new(@user)
  end

end
