require 'rails_helper'

RSpec.describe TransferMonthly, type: :model do

  let(:homer) { FactoryGirl.create(:user, :homer) }

  describe "#forecast" do

    it "should show the transfer occurring every month" do
      transfer_date = Date.today
      to_date = transfer_date+2.month

      transfer = FactoryGirl.create(:transfer_monthly, :incoming, user: homer, reference: "transfer", on: transfer_date, amount: 20)
      expect(transfer.forecast(transfer_date, to_date).count).to eq 3
    end

    context "when the from date is before the transfer's date" do
      it "should only show dates when the transfer will occur" do
        from_date = Date.today - 1.month
        transfer_date = from_date + 1.month
        to_date = from_date + 3.months

        transfer = FactoryGirl.create(:transfer_monthly, :incoming, user: homer, reference: "transfer", on: transfer_date, amount: 20)
        expect(transfer.forecast(from_date, to_date).count).to eq 3
      end
    end

    context "when the from date is not set" do
      it "should use the transfer date" do
        transfer_date = Date.today
        to_date = transfer_date+2.months

        transfer = FactoryGirl.create(:transfer_monthly, :incoming, user: homer, reference: "transfer", on: transfer_date, amount: 20)
        expect(transfer.forecast(to_date).count).to eq 3
      end
    end

    context "when the from date is greater than the to date" do
      it "should be empty" do
        transfer_date = Date.today
        from_date = Date.today + 1.month
        to_date = transfer_date - 1.month

        transfer = FactoryGirl.create(:transfer_monthly, :incoming, user: homer, reference: "transfer", on: transfer_date, amount: 20)
        expect(transfer.forecast(from_date, to_date)).to be_empty
      end
    end

    context "when the from date is equal to the to date" do
      it "should show transfers occurring on that day" do
        transfer_date = Date.today
        from_date = Date.today
        to_date = transfer_date

        transfer = FactoryGirl.create(:transfer_monthly, :incoming, user: homer, reference: "transfer", on: transfer_date, amount: 20)
        expect(transfer.forecast(from_date, to_date).count).to be 1
      end
    end

  end
end
