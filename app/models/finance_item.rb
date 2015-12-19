class FinanceItem

  attr_accessor :on, :balance, :diff, :running_monthly_diff

  def initialize(on, balance, difference, running_monthly_diff)
    @on = on.to_date
    @balance = balance
    @diff = difference
    @running_monthly_diff = running_monthly_diff
  end
end
