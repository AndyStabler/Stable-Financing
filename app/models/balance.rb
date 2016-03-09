class Balance < ActiveRecord::Base
  belongs_to :user

  validates :value, :on, :user, presence: { message: "Value cannot be empty" }
  validates :value, numericality: true

  def last_of_month?
    new_ordered_bals = user.balances.order(:on).group_by { |bal| bal.on.beginning_of_month }
    new_ordered_bals[on.beginning_of_month].sort_by { |bal| bal.on }.last == self
  end

  # Returns the difference between this value and the previous day's
  def diff_from_previous_day
    bals = user.balances.order(:on)
    ind = bals.index self

    # if it's the first balance return the balance value
    return value if ind == 0
    # group the balances by the day they occur on
    date_bals = user.balances.group_by { |b| b.on.to_date }
    # get the balances that have an on date less than the current balance's
    previous_balance = date_bals.select { |date, bals| date < on.to_date }.sort_by {|date, bals| date}
    # if there are no balances with an on date less than the current balance, return the current balance's value
    return value if previous_balance.blank?
    # previous_balance is an ordered Hash. Get the last hash item as an array, then get the last element (the hash value- an array of balances)
    # order these balances, and get the last's value
    value - previous_balance.last.last.sort_by {|b| b.on}.last.value
  end

  # Returns the difference between this balance and the previous one (might be on the same day)
  # they could both occur on the same day
  def diff_from_previous_balance
    bals = user.balances.order(:on)
    ind = bals.index self
    return value unless ind != 0
    # if the month is different to the previous balance's, then the diff is 0
    # previous balance is from same month? diff is balance - old balance
    bals[ind].value - bals[ind-1].value
  end

  def month_diff
    bals = user.balances.select {|b| b.on >= on.beginning_of_month && b.on <= on.end_of_month }
    bals.map(&:diff_from_previous_balance).inject(:+)
  end

end
