class BalanceCalculator

  def initialize(user)
    @user = user
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

  # Public: returns the balance on a given date
  #
  # Goes backwards from this date until a balance is found- this is the balance for this date
  # returns the balance
  def balance_on(date)
    @user.balances.all.select { |balance| balance.on.to_date <= date }
      .sort_by { |balance| balance.on }
      .last
  end

  private

  def last_balance_of_day date
    balances = @user.balances.all.select { |balance| balance.on.to_date == date }
    balances.sort_by { |balance| balance.on }.last
  end
end
