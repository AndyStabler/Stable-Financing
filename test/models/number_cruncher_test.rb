require 'test_helper'

class NumberCruncherTest < ActiveSupport::TestCase

    def setup
        @user = users(:andy)
        @finance_log = NumberCruncher.finance_log @user
        @finance_forecast = NumberCruncher.finance_forecast @user
    end

    test "logged balances should not take into account forecasting" do
        logged_balances = @finance_log.map(&:balance)
        forecasted_balances = @finance_forecast.map(&:balance)
        # byebug
        # get all logged balances from finance items

        # check they match the balances in the table logged by the user

    end

    test "future balances should be forecasted" do
        # get forecasted items

        # group_transfers_by_date between two date values
        # (calculates all fo the dates future transfers will occur)

        # for every date in this hash
        #   assert that the forecasted balabnce is equal to the previous balance + the sum of all transfers for this date

    end

    test "last balance of montth shows running monthly diff" do
        # get all finance items
        # select the last items of the month
        # assert that each has a runnig monthly diff value
    end

    test "non-last balance of the month should not show a monthly diff" do
        # get all finance items
        # select all but the last of every month
        # assert that each item has a null monthly diff
    end

    test "Change should equal previous balance subtract current balance" do
        # for every finance item (non-forecasted AND forecasted)
        # check that the current diff is equal to the previous balance subtract the current balance
    end

    test "First change should equal first balance" do

    end

end
