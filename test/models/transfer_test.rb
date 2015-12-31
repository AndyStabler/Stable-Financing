require 'test_helper'

class TransferTest < ActiveSupport::TestCase

  def setup
    @user = users(:andy)
    @all_transfers = @user.transfers.order(:on)
  end

  test "sum_outgoing returns correct total" do
    transfers = @user.transfers
    expected_total = transfers.select{ |tr| tr.outgoing }.map(&:amount).inject(:+)
    assert_equal expected_total, Transfer.sum_outgoing(transfers)
  end

  test "sum_incoming returns correct total" do
    transfers = @user.transfers
    expected_total = transfers.select{ |tr| !tr.outgoing }.map(&:amount).inject(:+)
    assert_equal expected_total, Transfer.sum_incoming(transfers)
  end

  test "sum_outgoing returns zero when no transfers" do
    transfers = users(:misty).transfers
    expected_total = 0
    assert_equal expected_total, Transfer.sum_outgoing(transfers)
  end

  test "sum_incoming returns zero when no transfers" do
    transfers = users(:misty).transfers
    expected_total = 0
    assert_equal expected_total, Transfer.sum_incoming(transfers)
  end

  test "group_transfers_by_date correctly forecasts non-recurring transfers" do
    non_recurring_transfers = @user.transfers.select { |tr| tr.recurrence.to_sym == :no }
    date_transfers = Transfer.group_transfers_by_date @user.transfers, @all_transfers.first.on.to_date,
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
    date_transfers = Transfer.group_transfers_by_date @user.transfers, @all_transfers.first.on.to_date,
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
    date_transfers = Transfer.group_transfers_by_date @user.transfers, @all_transfers.first.on.to_date,
                        @all_transfers.last.on.to_date+1.year

    # every weekly transfer should occur every week in the date_transfers hash
    weekly_transfers.each do |tr|
      week_date = tr.on.to_date
      loop do
        assert date_transfers[week_date].include? tr
        week_date+= 7.days
        break if week_date > date_transfers.sort_by { |d, _| d }.last[0].to_date
      end
    end

    # for every weekly transfer
    # remove the transfer from every week it should occur
    # After this, date_transfers should contain no weekly transfers
    weekly_transfers.each do |tr|
      week_date = tr.on.to_date
      loop do
        date_transfers[week_date].delete tr
        week_date+= 7.days
        break if week_date > date_transfers.sort_by { |d, _| d }.last[0].to_date
      end
    end
    # intersect of flattened transfers from date_transfers with weekly_transfers should be empty
    # we deleted each weekly transfer from the hash on the date we'd expect it to occur. let's check that it is not the case
    # that any weekly transfers occured on any other date.
    assert_equal (date_transfers.values.flatten & weekly_transfers), []
  end

  test "group_transfers_by_date correctly forecasts monthly transfers" do
    monthly_transfers = @user.transfers.select { |tr| tr.recurrence.to_sym == :monthly }
    date_transfers = Transfer.group_transfers_by_date @user.transfers, @all_transfers.first.on.to_date,
                        @all_transfers.last.on.to_date+1.year
    months_to_add = 0;
    monthly_transfers.each do |tr|
      month_date = tr.on.to_date
      loop do
        assert date_transfers[month_date].include? tr
        month_date = tr.on.to_date+months_to_add.months
        # you can't just say month_date+=1.month because 30+1.month => 29+1.month => 29+1.month is wrong, we sould go back to 30
        months_to_add+=1;
        break if month_date > date_transfers.sort_by { |d, _| d }.last[0]
      end
    end
  end
end
