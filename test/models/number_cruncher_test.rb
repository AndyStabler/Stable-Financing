require 'test_helper'

class NumberCruncherTest < ActiveSupport::TestCase

  def setup
    @user = users(:andy)
    @finance_log = finance_log @user
    @finance_forecast = finance_forecast @user
    @all_transfers = @user.transfers.order(:on)
    @number_cruncher = NumberCruncher.new(@user)
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
    date_to_transfers = Transfer.group_transfers_by_date(@all_transfers, @all_transfers.first.on.to_date,
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

end
