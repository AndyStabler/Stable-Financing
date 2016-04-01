require 'rails_helper'

RSpec.describe BalanceCalculator, type: :model do

  let(:homer) do
    FactoryGirl.create(:user, :homer)
  end

  let(:balance_calculator) do
    BalanceCalculator.new(homer)
  end

  describe "#forecast_balance" do
    context "to is before any transfers" do
      it "should be empty" do
        date = DateTime.now-1.day
        # make the initial balance be yesterday so it doesn't get in the way
        homer.balance.update_attributes(:on => DateTime.yesterday)
        FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 1", on: date + 1.day, amount: 20.0)
        FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 2", on: date + 1.day, amount: 20.0)
        FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 3", on: date + 2.days, amount: 20.0)
        FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 4", on: date + 2.days, amount: 40.0)
        forecast = balance_calculator.forecast_balance(date)
        expect(forecast).to be_empty
      end
    end

    it "should add a BalanceForecast for all transfers occurung on the dates" do
      first_date = DateTime.now
      second_date = first_date+1.day
      # make the initial balance be yesterday so it doesn't get in the way
      homer.balance.update_attributes(:on => DateTime.yesterday)
      FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 1", on: first_date, amount: 20.0)
      FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 2", on: first_date, amount: 20.0)
      FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 3", on: second_date, amount: 20.0)
      FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 4", on: second_date, amount: 40.0)
      forecast = balance_calculator.forecast_balance(second_date)
      expect(forecast.count).to eq 2
      expect(forecast.first.balance).to eq 40
      expect(forecast[1].balance).to eq 20
    end
  end

  describe "#forecast_balance_between" do
    before(:each) do
      FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 1", on: DateTime.now.end_of_month+1.week, amount: 20.0)
      FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 2", on: DateTime.now.end_of_month+2.weeks, amount: 20.0)
    end

    context "end_date is earlier than start_date" do
      it "should be empty" do
        from = DateTime.now
        to = DateTime.now-1.week
        expect(balance_calculator.forecast_balance_between(from, to)).to be_empty
      end
    end

    context "start_date is equal to end_date" do
      it "should return 1 finance item occuring on this day" do
        from = Date.today.end_of_month + 2.weeks
        to = Date.today.end_of_month + 2.weeks
        expect(balance_calculator.forecast_balance_between(from, to).count).to eq 1
      end
    end

    context "start_date is earlier than end_date" do
      it "should return finance items occurring between these dates" do
        from = Date.today.end_of_month+1.week
        to = Date.today.end_of_month+2.weeks
        expect(balance_calculator.forecast_balance_between(from, to).count).to eq 8
      end
    end
  end

  describe "#balance_log" do
    context "when there are multiple balances per day" do
      it "shows the last balance of the day" do
        first_time = DateTime.now.beginning_of_day+1.hour
        second_time = first_time+1.day
        # get rid of the initial balance
        homer.balances.destroy_all
        # add it back in at a predictable time
        FactoryGirl.create(:balance, on: first_time, user: homer, value: 0.0)
        FactoryGirl.create(:balance, on: first_time + 2.hours, user: homer, value: 20.0)
        FactoryGirl.create(:balance, on: first_time + 3.hour, user: homer, value: 50.0)
        FactoryGirl.create(:balance, on: second_time, user: homer, value: 20.0)
        FactoryGirl.create(:balance, on: second_time + 1.hour, user: homer, value: 10.0)
        balance_log = balance_calculator.balance_log(first_time, second_time)
        expect(balance_log.count).to eq 2
        expect(balance_log.first.value).to eq 50
        expect(balance_log[1].value).to eq 10
      end
    end
  end

end
