class Balance < ActiveRecord::Base
  belongs_to :user

  validates :value, :on, :user, presence: {message: "Value cannot be empty"}
  validates :value, numericality: true

  def last_of_month?
    new_ordered_bals = user.balances.order(:on).group_by { |bal| bal.on.beginning_of_month }
    new_ordered_bals[on.beginning_of_month].sort_by { |bal| bal.on }.last == self
  end

  def diff_from_previous_balance
    bals = user.balances.order(:on)
    ind = bals.index self #bals[self]
    # if it's the first in the list, just return the balance value
    return value unless ind != 0
    # if the month is different to the previous balance's, then the diff is 0
    # previous balance is from same month? diff is balance - old balance
    bals[ind].value - bals[ind-1].value
  end

  def month_diff
    bals = user.balances.where(on: on.beginning_of_month..on.end_of_month)
    bals.map(&:diff_from_previous_balance).inject(:+)
  end

end