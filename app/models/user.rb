class User < ActiveRecord::Base

  has_many :incoming, -> { where outgoing: false }, class_name: 'Transfer'
  has_many :outgoing, -> { where outgoing: true }, class_name: 'Transfer'
  has_many :balance, through: :Transfer

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

end