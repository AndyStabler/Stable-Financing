require 'rails_helper'

RSpec.describe Transfer, type: :model do

  describe ".group_transfers_by_date" do
    context "when there are no transfers" do
      it "should return an empty hash" do
        expect(Transfer.group_transfers_by_date [], Date.yesterday, Date.today).to be_empty
      end
    end

    context "when the end date is equal to the start date" do
      it "should return the transfers that apply on the start/end date" do
        FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 1", on: DateTime.now-10.days, amount: 20)
        FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 2", on: DateTime.now-5.days, amount: 20)
        the_date = Date.today
        expected_transfers = {the_date => homer.transfers}
        expect(Transfer.group_transfers_by_date(homer.transfers, the_date, the_date)).to eq(expected_transfers)
      end
    end

    context "when the end date is less than the start date" do
      it "should return an empty hash" do
        FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 1", on: DateTime.now-10.days, amount: 20)
        FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 2", on: DateTime.now-5.days, amount: 20)
        expect(Transfer.group_transfers_by_date(homer.transfers, DateTime.now, DateTime.now-1.day)).to be_empty
      end
    end

    context "when there are daily transfers" do
      it "should show transfers occurring everyday" do
        transfer = FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 1", on: DateTime.now-1.week, amount: 20)
        from_date = Date.today
        to_date = Date.today + 1.week
        date_transfers = Transfer.group_transfers_by_date(homer.transfers, from_date, to_date)

        # make sure the the number of transfers is correct
        expect(date_transfers.count).to eq ((to_date - Date.today).to_i + 1)
        # make sure each transfer is the transfer we set
        date_transfers.each do |date, transfers|
          expect(transfers.first).to eq transfer
        end
      end
    end

    context "when there are weekly transfers" do
      it "should show transfers occurring weekly" do
        from_date = Date.yesterday
        to_date = Date.today + 1.month

        transfer = FactoryGirl.create(:transfer, :incoming, :weekly, user: homer, reference: "transfer 1", on: Date.today-1.month-6.days, amount: 20)
        date_transfers = Transfer.group_transfers_by_date(homer.transfers, from_date, to_date)
        total_weeks = ((to_date - transfer.on.to_date) / 7).to_i + 1
        week_count = 0
        total_weeks.times { |i| week_count+=1 if (from_date..to_date).cover?(transfer.on + i.weeks) }

        expect(date_transfers.count).to eq (week_count)
      end
    end

    context "when there are monthly transfers" do
      it "should show transfers occurring monthly" do
        from_date = Date.today - 2.month
        to_date = Date.today + 2.month
        transfer = FactoryGirl.create(:transfer, :incoming, :monthly, user: homer, reference: "transfer 1", on: Date.today-1.month-6.days, amount: 20)
        date_transfers = Transfer.group_transfers_by_date(homer.transfers, from_date, to_date)
        total_months = (Util::DateTimeUtil.months_between(transfer.on, to_date)).to_i + 1
        month_count = 0
        total_months.times { |i| month_count+=1 if (from_date..to_date).cover?(transfer.on + i.months) }

        expect(date_transfers.count).to eq(month_count)
      end
    end

    context "when there are transfers with no recurrence" do
      it "should show the transfer only occuring on that date" do
        from_date = Date.today - 2.month
        to_date = Date.today + 2.month
        transfer = FactoryGirl.create(:transfer, :incoming, :no_recurrence, user: homer, reference: "transfer 1", on: Date.today, amount: 20)
        date_transfers = Transfer.group_transfers_by_date(homer.transfers, from_date, to_date)
        expect(date_transfers.count).to eq(1)
      end
    end

  end
end
