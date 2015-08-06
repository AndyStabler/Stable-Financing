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
  # creates a list of FinanceRows based on saved balance updates
  #
  def balance_data_between(start_date, end_date)
    # pointless going any further if there are no balance updates associated with this user
    return nil unless balances.any?

    relevant_balances = balances.where(on: start_date..end_date+1)
    # no balances for these dates
    return nil unless relevant_balances.any?

    rows = Array.new
    balance_groups = relevant_balances.group_by { |bal| bal.on.day_s } #(&:day_of_datetime)
    balance_groups.each do |day, bals|
      row_on = bals.last.on.day_s
      row_bal = bals.sort_by { |bal| bal[:on] }.last
      row_month_diff = bals.last.last_of_month? ? bals.last.month_diff : nil
      rows << FinanceRow.new(row_on, row_bal.value, row_bal.diff_from_previous_balance, row_month_diff)
    end
    rows
  end

  def all_balance_data
    bals = balances.order(:on)

    return nil unless bals.any?
    from = bals.first.on
    to = bals.last.on
    balance_data_between(from, to)
  end

  ##
  # creates a list of FinanceRows based on calculations from saved transfers
  #
  def prediction_data_between(start_date, end_date)
    # map from date
    trans_date_map = Hash.new

  end

  def all_prediction_data
    trans = transfers.order(:on)
    return nil unless trans.any?
    from = trans.first.on
    to = trans.last.on
    prediction_data_between(from, to)
  end

end