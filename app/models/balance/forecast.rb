# A Forecast is a non-persistant balance that has some extra information
# (stored on it)
# Using a delgator here so balance methods can be accessed directly on instances
# of this class
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
