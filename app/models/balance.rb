class Balance < ActiveRecord::Base
  belongs_to :user

  def last_of_month?
    new_ordered_bals = user.balances.order(:on).group_by { |bal| bal.on.beginning_of_month }
    new_ordered_bals[on.beginning_of_month].sort_by { |bal| bal.on }.last == self
  end

  def diff_from_previous_balance
    bals = user.balances.order(:on)
    ind = bals.index self #bals[self]
    # if it's the first in the list, there's no difference from previous balance
    return 0 unless ind != 0
    # if the month is different to the previous balance's, then the diff is 0
    # previous balance is from same month? diff is balance - old balance
    bals[ind].value - bals[ind-1].value
  end

  def month_diff
    bals = user.balances.where(on: on.beginning_of_month..on.end_of_month)
    diff = 0
    bal_store = nil
    bals.each do |bal|
      unless bal_store.nil?
        diff+= bal.value - bal_store
      end
      bal_store = bal.value
    end
    diff
  end

end
