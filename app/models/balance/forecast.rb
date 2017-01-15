class Balance::Forecast < Delegator

  attr_reader :balance, :transfers

  def initialize(balance: balance, transfers: transfers)
    @balance = balance
    @transfers = transfers
  end

  def __getobj__
    @balance
  end

  def __setobj__(balance)
    @balance = balance
  end

end
