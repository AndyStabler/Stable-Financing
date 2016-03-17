require 'rails_helper'

RSpec.describe Transfer, type: :model do

  let(:homer) do
    FactoryGirl.create(:user, :homer)
  end

  describe ".all_incoming" do
    context "when there are no incoming transfers" do
      it "should be empty" do
        expect(Transfer.all_incoming(homer.transfers)).to be_empty
      end
    end

    context "when there are only incoming transfers" do
      it "should return all transfers" do
        expected_transfers = []
        expected_transfers << FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 1", on: DateTime.now, amount: 20.0)
        expected_transfers << FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 2", on: DateTime.now, amount: 20.0)
        expected_transfers << FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 3", on: DateTime.now, amount: 20.0)
        expect(Transfer.all_incoming(homer.transfers)).to eql expected_transfers
      end
    end

    context "when there are a mix of incoming and outgoing transfers" do
      it "should return only the incoming transfers" do
       expected_transfers = []
       expected_transfers << FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 1", on: DateTime.now, amount: 20.0)
       expected_transfers << FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 2", on: DateTime.now, amount: 20.0)
       expected_transfers << FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 3", on: DateTime.now, amount: 20.0)
       FactoryGirl.create(:transfer, :outgoing, :daily, user: homer, reference: "transfer 4", on: DateTime.now, amount: 20.0)
       FactoryGirl.create(:transfer, :outgoing, :daily, user: homer, reference: "transfer 5", on: DateTime.now, amount: 20.0)
       FactoryGirl.create(:transfer, :outgoing, :daily, user: homer, reference: "transfer 6", on: DateTime.now, amount: 20.0)
       expect(Transfer.all_incoming(homer.transfers)).to eql expected_transfers
     end
   end
 end

 describe ".sum_incoming" do
    context "when there are no transfers" do
      it "should return 0" do
        expect(Transfer.sum_incoming(homer.transfers)).to be_zero
      end
    end

    context "when there are some transfers" do
      it "should return the total" do
        FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 1", on: DateTime.now, amount: 20.0)
        FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 2", on: DateTime.now, amount: 20.0)
        FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 3", on: DateTime.now, amount: 20.0)
        expect(Transfer.sum_incoming(homer.transfers)).to eql(60)
      end
    end
  end

  describe "all_outgoing" do
    context "when there are no outgoing transfers" do
      it "should be empty" do
        expect(Transfer.all_outgoing(homer.transfers)).to be_empty
      end
    end

    context "when there are only outgoing transfers" do
      it "should return all transfers" do
        expected_transfers = []
        expected_transfers << FactoryGirl.create(:transfer, :outgoing, :daily, user: homer, reference: "transfer 1", on: DateTime.now, amount: 20.0)
        expected_transfers << FactoryGirl.create(:transfer, :outgoing, :daily, user: homer, reference: "transfer 2", on: DateTime.now, amount: 20.0)
        expected_transfers << FactoryGirl.create(:transfer, :outgoing, :daily, user: homer, reference: "transfer 3", on: DateTime.now, amount: 20.0)
        expect(Transfer.all_outgoing(homer.transfers)).to eql expected_transfers
      end
    end

    context "when there are a mix of outgoing and incoming transfers" do
      it "should return only the outgoing transfers" do
        expected_transfers = []
        FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 1", on: DateTime.now, amount: 20.0)
        FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 2", on: DateTime.now, amount: 20.0)
        FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 3", on: DateTime.now, amount: 20.0)
        expected_transfers << FactoryGirl.create(:transfer, :outgoing, :daily, user: homer, reference: "transfer 4", on: DateTime.now, amount: 20.0)
        expected_transfers << FactoryGirl.create(:transfer, :outgoing, :daily, user: homer, reference: "transfer 5", on: DateTime.now, amount: 20.0)
        expected_transfers << FactoryGirl.create(:transfer, :outgoing, :daily, user: homer, reference: "transfer 6", on: DateTime.now, amount: 20.0)
        expect(Transfer.all_outgoing(homer.transfers)).to eql expected_transfers
      end
    end
  end

  describe ".sum_outgoing" do
    context "when there are no transfers" do
      it "should return 0" do
        expect(Transfer.sum_incoming(homer.transfers)).to be_zero
      end
    end

    context "when there are some transfers" do
      it "should return the total" do
        FactoryGirl.create(:transfer, :outgoing, :daily, user: homer, reference: "transfer 1", on: DateTime.now, amount: 20.0)
        FactoryGirl.create(:transfer, :outgoing, :daily, user: homer, reference: "transfer 2", on: DateTime.now, amount: 20.0)
        FactoryGirl.create(:transfer, :outgoing, :daily, user: homer, reference: "transfer 3", on: DateTime.now, amount: 20.0)
        expect(Transfer.sum_outgoing(homer.transfers)).to eql(60)
      end
    end
  end

  describe "group_transfers_by_date" do
    context "when there are no transfers" do
    end

    context "when the end date is equal to the start date" do
    end

    context "when the end date is less than the start date" do
    end

    context "when there are daily transfers" do
    end

    context "when there are weekly transfers" do
    end

    context "when there are monthly transfers" do
    end

    context "when there are daily, weekly, and monthly transfers" do

    end
  end
end
