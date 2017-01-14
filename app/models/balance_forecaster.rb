class BalanceForecaster

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
    balance = balance.value

    transfer_dates.sort.each do |transfer_date|
      transfers = @transfer_calculator.transfers_occurring_on transfer_date
      diff = TransferCalculator.total_difference transfers
      balance+= diff
      balance_forecasts << BalanceForecast.new(transfer_date, balance, transfers)
    end
    balance_forecasts
  end
end
