class Balance::Forecaster

  def initialize(user)
    @user = user
    @transfer_calculator = TransferCalculator.new @user
  end

  def forecast_balance(to)
    balance_forecasts = []
    balance = @user.balance
    # get all transfer dates occurring after the user's latest balance update
    from = balance.on.to_date + 1.day
    transfer_dates = @transfer_calculator.all_transfer_dates(from, to)
    balance_value = balance.value

    transfer_dates.sort.each do |transfer_date|
      transfers = @transfer_calculator.transfers_occurring_on transfer_date
      diff = TransferCalculator.total_difference transfers
      balance_value+= diff
      balance = Balance.new(value: balance_value, on: transfer_date, user: @user)
      balance_forecasts << Balance::Forecast.new(balance: balance, transfers: transfers)
    end
    balance_forecasts
  end
end
