class Balance::Calculator

  def initialize(balances)
    @balances = balances
  end

  def balance_log(from = nil, to)
    from ||= @balances.first.on
    balance_dates = @balances.select { |balance| balance.on >= from && balance.on <= to }
      .map { |balance| balance.on.to_date }
      .uniq
    balance_dates.map { |balance_date| last_balance_of_day balance_date }
  end

  private

  def last_balance_of_day date
    balances = @balances.select { |balance| balance.on.to_date == date }
    balances.sort_by { |balance| balance.on }.last
  end
end
