class Balance < ActiveRecord::Base
  belongs_to :user

  def last_of_month?
    ordered_bals = user.balances.order(:on)
    # true if day is last day of month
    return true unless on.day != on.end_of_month.day
    # true if this balance is the last in the db
    return true unless ordered_bals.last != self
    # true if month is different to the next balance's in the DB
    # just because the months are equal, it's not necessarily the case that the years are equal!
    return true unless on.month == ordered_bals[ordered_bals.index(self)+1].on.month &&
        on.year == ordered_bals[ordered_bals.index(self)+1].on.year

    false
  end

  def diff_from_previous_balance
    bals = user.balances.order(:on)
    ind = bals.index self #bals[self]
    # if it's the first in the list, there's no difference from previous balance
    return 0 unless ind != 0
    # if the month is different to the previous balance's, then the diff is 0
    #return 0 unless bals[ind].on.month == bals[ind-1].on.month && bals[ind].on.year == bals[ind-1].on.year
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
