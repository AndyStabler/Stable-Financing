require 'rails_helper'

RSpec.describe BalanceForecaster, type: :model do

  let(:homer) do
    FactoryGirl.create(:user, :homer)
  end

  let(:balance_forecaster) do
    BalanceForecaster.new(homer)
  end

  describe "#forecast_balance" do
    context "to is before any transfers" do
      it "should be empty" do
        date = DateTime.current-1.day
        # make the initial balance be yesterday so it doesn't get in the way
        homer.balance.update_attributes(:on => DateTime.yesterday)
        FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 1", on: date + 1.day, amount: 20.0)
        FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 2", on: date + 1.day, amount: 20.0)
        FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 3", on: date + 2.days, amount: 20.0)
        FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 4", on: date + 2.days, amount: 40.0)
        forecast = balance_forecaster.forecast_balance(date)
        expect(forecast).to be_empty
      end
    end

    it "should add a BalanceForecast for all transfers occurung on the dates" do
      first_date = DateTime.current
      second_date = first_date+1.day
      # make the initial balance be yesterday so it doesn't get in the way
      homer.balance.update_attributes(:on => DateTime.yesterday)
      FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 1", on: first_date, amount: 20.0)
      FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 2", on: first_date, amount: 20.0)
      FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 3", on: second_date, amount: 20.0)
      FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 4", on: second_date, amount: 40.0)
      forecast = balance_forecaster.forecast_balance(second_date)
      expect(forecast.count).to eq 2
      expect(forecast.first.balance).to eq 40
      expect(forecast[1].balance).to eq 20
    end
  end

  describe "#forecast_balance_between" do
    before(:each) do
      FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 1", on: DateTime.current.end_of_month+1.week, amount: 20.0)
      FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 2", on: DateTime.current.end_of_month+2.weeks, amount: 20.0)
    end

    context "end_date is earlier than start_date" do
      it "should be empty" do
        from = DateTime.current
        to = DateTime.current-1.week
        expect(balance_forecaster.forecast_balance_between(from, to)).to be_empty
      end
    end

    context "start_date is equal to end_date" do
      it "should return 1 finance item occuring on this day" do
        from = Date.today.end_of_month + 2.weeks
        to = Date.today.end_of_month + 2.weeks
        expect(balance_forecaster.forecast_balance_between(from, to).count).to eq 1
      end
    end

    context "start_date is earlier than end_date" do
      it "should return finance items occurring between these dates" do
        from = Date.today.end_of_month+1.week
        to = Date.today.end_of_month+2.weeks
        expect(balance_forecaster.forecast_balance_between(from, to).count).to eq 8
      end
    end
  end
end
