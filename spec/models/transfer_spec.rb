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
      expect {transfer.recurrence}.to raise_error(NameError)
    end
  end

  describe ".incoming" do

    context "when there are no incoming transfers" do
      it "should be empty" do
        expect(Transfer.incoming(homer)).to be_empty
      end
    end

    context "when there are only incoming transfers" do
      it "should return all transfers" do
        expected_transfers = []
        expected_transfers << FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 1", on: DateTime.current, amount: 20.0)
        expected_transfers << FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 2", on: DateTime.current, amount: 20.0)
        expected_transfers << FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 3", on: DateTime.current, amount: 20.0)
        expect(Transfer.incoming(homer).to_a).to eql expected_transfers
      end
    end

    context "when there are a mix of incoming and outgoing transfers" do
      it "should return only the incoming transfers" do
        expected_transfers = []
        expected_transfers << FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 1", on: DateTime.current, amount: 20.0)
        expected_transfers << FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 2", on: DateTime.current, amount: 20.0)
        expected_transfers << FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 3", on: DateTime.current, amount: 20.0)
        FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 4", on: DateTime.current, amount: 20.0)
        FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 5", on: DateTime.current, amount: 20.0)
        FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 6", on: DateTime.current, amount: 20.0)
        expect(Transfer.incoming(homer).to_a).to eql expected_transfers
      end
    end
  end

  describe ".outgoing" do

    context "when there are no outgoing transfers" do
      it "should be empty" do
        expect(Transfer.outgoing(homer)).to be_empty
      end
    end

    context "when there are only outgoing transfers" do
      it "should return all transfers" do
        expected_transfers = []
        expected_transfers << FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 1", on: DateTime.current, amount: 20.0)
        expected_transfers << FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 2", on: DateTime.current, amount: 20.0)
        expected_transfers << FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 3", on: DateTime.current, amount: 20.0)
        expect(Transfer.outgoing(homer).to_a).to eql expected_transfers
      end
    end

    context "when there are a mix of outgoing and outgoing transfers" do
      it "should return only the outgoing transfers" do
        expected_transfers = []
        expected_transfers << FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 1", on: DateTime.current, amount: 20.0)
        expected_transfers << FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 2", on: DateTime.current, amount: 20.0)
        expected_transfers << FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 3", on: DateTime.current, amount: 20.0)
        FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 4", on: DateTime.current, amount: 20.0)
        FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 5", on: DateTime.current, amount: 20.0)
        FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 6", on: DateTime.current, amount: 20.0)
        expect(Transfer.outgoing(homer).to_a).to eql expected_transfers
      end
    end
  end
end
