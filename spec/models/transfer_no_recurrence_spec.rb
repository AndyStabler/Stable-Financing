require 'rails_helper'

RSpec.describe TransferNoRecurrence, type: :model do

  let(:homer) { FactoryGirl.create(:user, :homer) }

  describe "#forecast" do

    context "when from is nil" do
      context "and to is the transfer date" do
        it "should be an array of 1" do
          transfer_date = Date.today
          to_date = transfer_date

          transfer = FactoryGirl.create(:transfer_no_recurrence, :incoming, user: homer, reference: "trnsfer", on: transfer_date, amount: 20)
          expect(transfer.forecast(to_date).count).to eq 1
        end
      end

      context "and to is before the transfer date" do
        it "should be empty" do
          transfer_date = Date.today
          to_date = transfer_date - 1.day

          transfer = FactoryGirl.create(:transfer_no_recurrence, :incoming, user: homer, reference: "trnsfer", on: transfer_date, amount: 20)
          expect(transfer.forecast(to_date)).to be_empty
        end
      end

      it "should be an array of 1" do
        transfer_date = Date.today
        to_date = transfer_date+1.week

        transfer = FactoryGirl.create(:transfer_no_recurrence, :incoming, user: homer, reference: "trnsfer", on: transfer_date, amount: 20)
        expect(transfer.forecast(to_date).count).to eq 1
      end
    end

    context "when from is less than to" do
      # Happy case
      it "should be an array of 1" do
        transfer_date = Date.today
        from_date = transfer_date-1.day
        to_date = transfer_date + 1.day

        transfer = FactoryGirl.create(:transfer_no_recurrence, :incoming, user: homer, reference: "trnsfer", on: transfer_date, amount: 20)
        expect(transfer.forecast(from_date, to_date).count).to eq 1
      end

      context "and transfer date is less than from" do
        it "should be empty" do
          transfer_date = Date.today
          from_date = transfer_date + 1.day
          to_date = transfer_date + 2.days

          transfer = FactoryGirl.create(:transfer_no_recurrence, :incoming, user: homer, reference: "trnsfer", on: transfer_date, amount: 20)
          expect(transfer.forecast(from_date, to_date)).to be_empty
        end
      end

      context "and transfer date is greater than to" do
        it "should be empty" do
          transfer_date = Date.today
          from_date = transfer_date - 2.days
          to_date = transfer_date - 1.day

          transfer = FactoryGirl.create(:transfer_no_recurrence, :incoming, user: homer, reference: "trnsfer", on: transfer_date, amount: 20)
          expect(transfer.forecast(from_date, to_date)).to be_empty
        end
      end
    end

  end
end
