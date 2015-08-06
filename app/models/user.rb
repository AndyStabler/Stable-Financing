class User < ActiveRecord::Base

  has_many :transfers
  # many balances over time - store them so the user can see what's going on
  has_many :balances

  def incoming
    transfers.where(outgoing: false)
  end

  def outgoing
    transfers.where(outgoing: true)
  end

  ##
  # Let's start by creating a row for every day, but there's no reason we couldn't let the user specify
  # the unit of time they wish each row to represent (day/week/month, etc)
  #
  def finance_rows_between(start_date, end_date)
    days = (end_date.to_date - start_date.to_date).to_i
    rows = Array.new
    days.times do |i|
      day = start_date+i.days #+0 days, +1 day, +2 days, etc.
      # get latest (with respect to start_date) balance for this user

      #balance


      #rows.add FinanceRow.new
    end
  end

  ##
  # Returns the balance for the user on a given date
  #
  # If the date is in the future, then the incoming and outgoings are used to
  # predict the balance the user will have at that time
  #
  # If the date is not in the future, then the current balance associated with
  # this user is returned
  def balance_on in_date

    if in_date.today?
      logger.debug "date(#{in_date}) is today"
      return balance
    else
      logger.debug "date(#{in_date}) is NOT today"
    end

    # get all Transfers where date is >= today <= in_date
    trans = incoming.where('dat > ? AND dat <= ?', DateTime.now, in_date)
    trans.each do |tr|
      # tr.
    end

  end

  private

  def days_between start_date, end_date

  end

end