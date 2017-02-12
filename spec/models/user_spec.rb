require 'rails_helper'

RSpec.describe User, type: :model do

  let(:homer) do
    FactoryGirl.create(:user, :homer)
  end

  describe "#balance_data" do
    it "should be a combination of log and forecast" do
      balance_data = homer.balance_data
      expect(balance_data[0]).to eq(homer.balance_log)
      expect(balance_data[1]).to eq(homer.balance_forecast)
    end
  end

  describe "#balance_forecast" do
    context "when there are no transfers" do
      it "should be empty" do
        expect(homer.balance_forecast).to be_empty
      end
    end

    context "when there are transfers" do
      it "should not be empty" do
        FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 1", on: Date.current, amount: 20.0)
        FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 2", on: Date.current, amount: 20.0)
        expect(homer.balance_forecast).to_not be_empty
      end
    end
  end

  it "adds an initial balance on creation" do
    expect(homer.balance).to be_present
  end
end
