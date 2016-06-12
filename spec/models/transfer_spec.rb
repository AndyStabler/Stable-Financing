require 'rails_helper'

RSpec.describe Transfer, type: :model do

  let(:homer) do
    FactoryGirl.create(:user, :homer)
  end

  let(:transfer) do
    FactoryGirl.create(:transfer, :incoming, user: homer, reference: "transfer 1", on: DateTime.current-10.days, amount: 20)
  end
  describe "#forecast" do
    it "should fail" do
      expect{transfer.forecast(Date.yesterday, Date.tomorrow)}.to raise_error(NotImplementedError)
    end
  end

  describe "#recurrence" do
    it "should fail" do
      expect {transfer.class.recurrence}.to raise_error(NotImplementedError)
    end
  end
end
