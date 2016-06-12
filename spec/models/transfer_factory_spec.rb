require 'rails_helper'

RSpec.describe TransferFactory, type: :model do

  describe ".build" do
    context "when the recurrence is a daily recurrence" do
      it "should return a TransferDaily" do
        transfer = FactoryGirl.build(:transfer_daily)
        expect(TransferFactory.build(TransferDaily.recurrence, transfer.attributes).class).to eq TransferDaily
      end
    end

    context "when the recurrence is a weekly recurrence" do
      it "should return a TransferWeekly" do
        transfer = FactoryGirl.build(:transfer_weekly)
        expect(TransferFactory.build(TransferWeekly.recurrence, transfer.attributes).class).to eq TransferWeekly
      end
    end

    context "when the recurrence is a monthly recurrence" do
      it "should return a TransferMonthly" do
        transfer = FactoryGirl.build(:transfer_monthly)
        expect(TransferFactory.build(TransferMonthly.recurrence, transfer.attributes).class).to eq TransferMonthly
      end
    end

    context "when the recurrence is a no recurrence" do
      it "should return a TransferNoRecurrence" do
        transfer = FactoryGirl.build(:transfer_no_recurrence)
        expect(TransferFactory.build(TransferNoRecurrence.recurrence, transfer.attributes).class).to eq TransferNoRecurrence
      end
    end
  end
end
