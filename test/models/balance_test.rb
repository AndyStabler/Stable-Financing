require 'test_helper'

class BalanceTest < ActiveSupport::TestCase

    test "diff_from_previous_day when value greater than previous day" do
      expected = balances(:previous_day_3).value - balances(:previous_day_2).value
      assert_equal expected, balances(:previous_day_3).diff_from_previous_day
    end

    test "diff_from_previous_day when value less than previous day" do
      expected = balances(:previous_day_4).value - balances(:previous_day_2).value
      assert_equal expected.to_f, balances(:previous_day_4).diff_from_previous_day.to_f
    end

end
