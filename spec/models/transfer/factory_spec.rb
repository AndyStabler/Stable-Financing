require 'rails_helper'

RSpec.describe Transfer::Factory, type: :model do

  describe ".build" do
    context "when the recurrence is a daily recurrence" do
      it "should return a Transfer::Daily" do
        transfer = FactoryGirl.build(:transfer_daily)
        expect(Transfer::Factory.build(Transfer::Daily::RECURRENCE, transfer.attributes).class).to eq Transfer::Daily
      end
    end

    context "when the recurrence is a weekly recurrence" do
      it "should return a Transfer::Weekly" do
        transfer = FactoryGirl.build(:transfer_weekly)
        expect(Transfer::Factory.build(Transfer::Weekly::RECURRENCE, transfer.attributes).class).to eq Transfer::Weekly
      end
    end

    context "when the recurrence is a monthly recurrence" do
      it "should return a Transfer::Monthly" do
        transfer = FactoryGirl.build(:transfer_monthly)
        expect(Transfer::Factory.build(Transfer::Monthly::RECURRENCE, transfer.attributes).class).to eq Transfer::Monthly
      end
    end

    context "when the recurrence is a no recurrence" do
      it "should return a Transfer::NoRecurrence" do
        transfer = FactoryGirl.build(:transfer_no_recurrence)
        expect(Transfer::Factory.build(Transfer::NoRecurrence::RECURRENCE, transfer.attributes).class).to eq Transfer::NoRecurrence
      end
    end

    context "when the recurrence isn't recognised" do
      it "should return a base transfer" do
        transfer = FactoryGirl.build(:transfer)
        expect(Transfer::Factory.build("unknown", transfer.attributes).class).to eq Transfer
      end
    end
  end
end
