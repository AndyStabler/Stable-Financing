class FinanceRow

  attr_accessor :on, :in_val, :out_val, :balance, :diff, :running_monthly_diff

  def initialize(on, in_val, out_val, balance, running_monthly_diff)
    @on = on
    @in_val = in_val
    @out_val = out_val
    @balance = balance
    @diff = @in_val -@out_val
    @running_monthly_diff = running_monthly_diff
  end
end