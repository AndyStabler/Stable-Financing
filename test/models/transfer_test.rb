require 'test_helper'

class TransferTest < ActiveSupport::TestCase

  def setup
    @user = users(:andy)
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
end
