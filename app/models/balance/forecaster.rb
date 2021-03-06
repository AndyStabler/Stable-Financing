class Balance::Forecaster

  def initialize(user)
    @user = user
    @transfer_calculator = Transfer::Calculator.new @user
  end

  def forecast_balance(to)
    balance_forecasts = []
    # get all transfer dates occurring after the user's latest balance update
    from = @user.balance.on.tomorrow.to_date

    transfer_dates = @transfer_calculator.all_transfer_dates(from, to)
    balance_value = @user.balance.value

    transfer_dates.sort.each do |transfer_date|
      transfers = @transfer_calculator.transfers_occurring_on transfer_date
      diff = Transfer::Calculator.total_difference transfers
      balance_value+= diff
      balance = Balance.new(value: balance_value, on: transfer_date, user: @user)
      balance_forecasts << Balance::Forecast.new(balance: balance, transfers: transfers)
    end
    balance_forecasts
  end

  def balance_forecast_on(transfer_date)
    forecast_balance(transfer_date).last
  end

end
