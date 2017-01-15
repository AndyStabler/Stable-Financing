require 'rails_helper'

RSpec.describe TransferCalculator, type: :model do

  let(:homer) do
    FactoryGirl.create(:user, :homer)
  end

  let(:transfer_calculator) do
    TransferCalculator.new(homer)
  end

  describe "#total_incoming" do
    context "when there are no transfers" do
      it "should return 0" do
        expect(transfer_calculator.total_incoming).to be_zero
      end
    end

    context "when there are some transfers" do
      it "should return the total" do
        FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 1", on: DateTime.current, amount: 20.0)
        FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 2", on: DateTime.current, amount: 20.0)
        FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 3", on: DateTime.current, amount: 20.0)
        expect(transfer_calculator.total_incoming).to eql(60)
      end
    end
  end

  describe "#total_outgoing" do
    context "when there are no transfers" do
      it "should return 0" do
        expect(transfer_calculator.total_incoming).to be_zero
      end
    end

    context "when there are some transfers" do
      it "should return the total" do
        FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 1", on: DateTime.current, amount: 20.0)
        FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 2", on: DateTime.current, amount: 20.0)
        FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 3", on: DateTime.current, amount: 20.0)
        expect(transfer_calculator.total_outgoing).to eql(60)
      end
    end
  end

  describe "#transfers_occurring_on" do
    it "should be the transfers occurring on this day" do
      on = DateTime.current
      FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 1", on: on - 1.day, amount: 20.0)
      FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 2", on: on, amount: 20.0)
      FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 3", on: on, amount: 20.0)
      FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 4", on: on + 1.day, amount: 20.0)
      occurring = transfer_calculator.transfers_occurring_on Date.today
      expect(occurring.count).to be 3
      expect(occurring.map(&:reference).sort == ["transfer 1", "transfer 2", "transfer 3"])
    end
  end
end
