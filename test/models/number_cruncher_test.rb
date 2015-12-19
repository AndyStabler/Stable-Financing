require 'test_helper'

class NumberCruncherTest < ActiveSupport::TestCase

  def setup
    @user = users(:andy)
    @finance_log = NumberCruncher.finance_log @user
    @finance_forecast = NumberCruncher.finance_forecast @user
    @all_transfers = @user.transfers.order(:on)
  end

  test "logged balances should not take into account forecasting" do
    # get all logged balances from finance items
    log_balances = @finance_log.map(&:balance)
    # actual_balances = @user.balances.map(&:value)
    actual_balances = @user.balances.group_by{ |b| b.on.to_date}.sort_by{|day, bals| day}.map{ |day, bals| bals.sort_by{ |b| b.on }.last.value }
    # check they match the balances in the table logged by the user
    assert_equal actual_balances, log_balances
  end

  test "future balances should be forecasted" do
    date_to_transfers = NumberCruncher.group_transfers_by_date(@all_transfers, @all_transfers.first.on.to_date,
     @all_transfers.last.on.to_date+1.year)
    .select { |day, _| day > @user.balance.on }


    # for every item
    #   assert that the forecasted balance is equal to the previous balance + the sum of all transfers for this date

    @finance_forecast.sort_by { |fi| fi.on }.each_with_index do |item, index|
      outgoing = Transfer.sum_outgoing date_to_transfers[item.on]
      incoming = Transfer.sum_incoming date_to_transfers[item.on]
      total = -outgoing + incoming + (index == 0 ? @user.balance.value : 0.0)
      next if index == 0
      expected = @finance_forecast[index - 1].balance + total
      assert_equal expected, @finance_forecast[index].balance
    end
  end

  test "last balance of month shows correct running monthly diff" do
    # get all finance items
    # select the last items of the month
    # assert that each has a runnig monthly diff value
    month_finance_items = (@finance_log + @finance_forecast).select { |item| !item.running_monthly_diff.nil? }
    month_finance_items.each_with_index do |item, index|
      next if index == 0
      assert_equal item.running_monthly_diff, (item.balance - month_finance_items[index-1].balance)
    end
  end

  test "monthly diff only present when item is last of momth" do
    check_monthly_diff_has_correct_occurence @finance_log
    check_monthly_diff_has_correct_occurence @finance_forecast
  end

  # if the finance item is the last of the month (the next item has a different month value)
  # or it is the last item in the list, then the item.monthly_diff should not be nil else should be nil
  def check_monthly_diff_has_correct_occurence finance_items
    finance_items.each_with_index do |item, index|
      # if last in list, or last in month
      if index == (finance_items.length-1) || item.on.month != finance_items[index+1].on.month
        assert_not_nil item.running_monthly_diff
      else
        assert_nil item.running_monthly_diff
      end
    end
  end

  test "change should equal previous balance subtract current balance" do
    # for every finance item (non-forecasted AND forecasted)
    # check that the current diff is equal to the current balance subtract the previous balance
    all_finance_items = (@finance_log + @finance_forecast)
    all_finance_items.each_with_index do |item, index|
      next if index == 0
      assert_equal item.diff, item.balance - all_finance_items[index - 1].balance
    end
  end

  test "first change should equal first balance" do
    assert_not_nil (@finance_log + @finance_forecast).first.diff
  end

  test "last balance of day used to calculate change from previous day" do
    balances = @user.balances.group_by { |b| b.on.to_date }
    @finance_log.each do |item|
      assert_equal item.balance, balances[item.on].sort_by { |b| b.on }.last.value
    end
  end

  test "group_transfers_by_date correctly forecasts non-recurring transfers" do
    non_recurring_transfers = @user.transfers.select { |tr| tr.recurrence.to_sym == :no }
    date_transfers = NumberCruncher.group_transfers_by_date @user.transfers, @all_transfers.first.on.to_date,
                        @all_transfers.last.on.to_date+1.year

    # check that the transfers are occuring on their specified date
    non_recurring_transfers.each do |tr|
      assert date_transfers[tr.on.to_date].include? tr
    end

    # reject elements that have same date as non-recurring transfers
    # non-recurring transfers, should never appear now
    date_transfers.reject { |date, trs| (non_recurring_transfers.map{|tr| tr.on.to_date } & [date]).present? }.each do |date, trs|
      # interset non_recurring with transfers for this day
      # the result should be empty always
      assert (non_recurring_transfers & trs).empty?
    end

  end

  # daily = [trans1, trans3]
  # all = [trans1, trans2, trans3]
  # day_trans = {day1 => [trans1, trans3], day2 => [trans1, trans2, trans3]}
  # for every day
  #  daily - day_trans[day] should be empty
  test "group_transfers_by_date correctly forecasts daily transfers" do
    # get the daily transfers
    daily_transfers = @user.transfers.select { |tr| tr.recurrence.to_sym == :daily }
    # get a hash, mapping dates to transfers
    date_transfers = NumberCruncher.group_transfers_by_date @user.transfers, @all_transfers.first.on.to_date,
                        @all_transfers.last.on.to_date+1.year

    date_transfers.each do |date, trs|
      # get the daily transfers that should appear on this date
      # if a transfer starts after the date we're looking at, then it shouldn't appear
      relevant_daily_transfers = daily_transfers.select { |daily_tr| daily_tr.on <= date }
      assert (relevant_daily_transfers - trs).empty?
    end
  end

  test "group_transfers_by_date correctly forecasts weekly transfers" do
    weekly_transfers = @user.transfers.select { |tr| tr.recurrence.to_sym == :weekly }
    date_transfers = NumberCruncher.group_transfers_by_date @user.transfers, @all_transfers.first.on.to_date,
                        @all_transfers.last.on.to_date+1.year

    # every weekly transfer should occur every week in the date_transfers hash
    weekly_transfers.each do |tr|
      week_date = tr.on.to_date
      loop do
        assert date_transfers[week_date].include? tr
        week_date+= 7.days
        break if week_date >= date_transfers.sort_by { |d, _| d }.last[0]
      end
    end

    # for every weekly transfer
    # remove the transfer from every week it should occur

    weekly_transfers.each do |tr|
      week_date = tr.on.to_date
      loop do
        date_transfers[week_date].delete tr
        week_date+= 7.days
        break if week_date >= date_transfers.sort_by { |d, _| d }.last[0]
      end
    end
    # intersect of flattened transfers from date_transfers with weekly_transfers should be empty
    assert_equal (date_transfers.values.flatten & weekly_transfers), []
  end

  test "group_transfers_by_date correctly forecasts monthly transfers" do
    monthly_transfers = @user.transfers.select { |tr| tr.recurrence.to_sym == :monthly }
    date_transfers = NumberCruncher.group_transfers_by_date @user.transfers, @all_transfers.first.on.to_date,
                        @all_transfers.last.on.to_date+1.year
    months_to_add = 0;
    monthly_transfers.each do |tr|
      month_date = tr.on.to_date
      loop do
        assert date_transfers[month_date].include? tr
        month_date = tr.on.to_date+months_to_add.months
        # you can't just say month_date+=1.month because 30+1.month => 29+1.month => 29+1.month is wrong, we sould go back to 30
        months_to_add+=1;
        break if month_date >= date_transfers.sort_by { |d, _| d }.last[0]
      end
    end
  end

end
