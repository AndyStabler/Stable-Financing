require 'rails_helper'

RSpec.describe NumberCruncher, type: :model do

  let(:homer) do
    FactoryGirl.create(:user, :homer)
  end

  let(:number_cruncher) do
    FactoryGirl.build(:number_cruncher, :user => homer)
  end

  describe "#calculate_balance_forecast" do
  end

  describe "#trans_per_month" do

    let (:date_to_transfers) do
      Transfer.group_transfers_by_date
    end

    context "when date_to_transfers is empty" do
      it "should be empty" do
        transfers_per_month = number_cruncher.trans_per_month([])
        expect(transfers_per_month).to be_empty
      end
    end

    context "when all transfers occur on the same month" do
      before(:each) do
        FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 1", on: DateTime.now.beginning_of_month, amount: 20.0)
        FactoryGirl.create(:transfer, :outgoing, :daily, user: homer, reference: "transfer 2", on: DateTime.now.beginning_of_month+1.day, amount: 20.0)
        FactoryGirl.create(:transfer, :incoming, :weekly, user: homer, reference: "transfer 3", on: DateTime.now.beginning_of_month+5.days, amount: 20.0)
        FactoryGirl.create(:transfer, :outgoing, :monthly, user: homer, reference: "transfer 4", on: DateTime.now.beginning_of_month+2.weeks, amount: 20.0)
      end

      it "should only have transfers for the given month" do
        from = DateTime.now.beginning_of_month
        to = DateTime.now.end_of_month
        transfers_per_month = number_cruncher.trans_per_month(Transfer.group_transfers_by_date(homer.transfers, from, to))
        expect(transfers_per_month.count).to eq 1
      end
    end

    context "when transfers span over 2 months" do
      before(:each) do
        FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 1", on: DateTime.now.beginning_of_month, amount: 20.0)
        FactoryGirl.create(:transfer, :outgoing, :daily, user: homer, reference: "transfer 2", on: DateTime.now.beginning_of_month+1.month + 5.days, amount: 20.0)
        FactoryGirl.create(:transfer, :incoming, :weekly, user: homer, reference: "transfer 3", on: DateTime.now.beginning_of_month+5.days, amount: 20.0)
        FactoryGirl.create(:transfer, :outgoing, :monthly, user: homer, reference: "transfer 4", on: DateTime.now.beginning_of_month+2.weeks, amount: 20.0)
      end

      it "should only have transfers for those 2 months" do
       from = DateTime.now.beginning_of_month
       to = (DateTime.now.beginning_of_month+1.month).end_of_month
       transfers_per_month = number_cruncher.trans_per_month(Transfer.group_transfers_by_date(homer.transfers, from, to))
       expect(transfers_per_month.count).to eq 2
      end
    end

    context "when transfers occur on the same month of different years" do
      before(:each) do
        FactoryGirl.create(:transfer, :incoming, :no_recurrence, user: homer, reference: "transfer 1", on: DateTime.now, amount: 20.0)
        FactoryGirl.create(:transfer, :incoming, :no_recurrence, user: homer, reference: "transfer 2", on: DateTime.now.beginning_of_month-1.year, amount: 20.0)
        FactoryGirl.create(:transfer, :outgoing, :no_recurrence, user: homer, reference: "transfer 3", on: DateTime.now.beginning_of_month+1.year, amount: 20.0)
      end

      it "should not show all transfers occuring in the same month" do
        from = DateTime.now.beginning_of_month - 1.year
        to = DateTime.now.beginning_of_month + 1.year
        transfers_per_month = number_cruncher.trans_per_month(Transfer.group_transfers_by_date(homer.transfers, from, to))
        expect(transfers_per_month.count).to eq 3
      end
    end
  end

  describe "#balance_forecast_between" do
    before(:each) do
      FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 1", on: DateTime.now.end_of_month+1.week, amount: 20.0)
      FactoryGirl.create(:transfer, :incoming, :daily, user: homer, reference: "transfer 2", on: DateTime.now.end_of_month+2.weeks, amount: 20.0)
    end

    context "end_date is earlier than start_date" do
      it "should be empty" do
        from = DateTime.now
        to = DateTime.now-1.week
        expect(number_cruncher.balance_forecast_between(from, to)).to be_empty
      end
    end

    context "start_date is equal to end_date" do
      it "should return 1 finance item occuring on this day" do
        from = Date.today.end_of_month + 2.weeks
        to = Date.today.end_of_month + 2.weeks
        expect(number_cruncher.balance_forecast_between(from, to).count).to eq 1
      end
    end

    context "start_date is earlier than end_date" do
      it "should return finance items occurring between these dates" do
        from = Date.today.end_of_month+1.week
        to = Date.today.end_of_month+2.weeks
        expect(number_cruncher.balance_forecast_between(from, to).count).to eq 8
      end
    end
  end

  describe "#finance_log_between" do
  end
end
