require 'rails_helper'

RSpec.describe Balance::Forecaster, type: :model do

  let(:homer) do
    FactoryGirl.create(:user, :homer)
  end

  let(:balance_forecaster) do
    Balance::Forecaster.new(homer)
  end

  before do
    # make the initial balance be yesterday so it doesn't get in the way
    homer.balance.update_attributes on: DateTime.yesterday
  end

  describe "#forecast_balance" do
    it "is empty when `to` is before any transfers" do
      to = DateTime.current.yesterday
      FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 1", on: to + 1.day, amount: 20.0)
      FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 2", on: to + 1.day, amount: 20.0)
      FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 3", on: to + 2.days, amount: 20.0)
      FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 4", on: to + 2.days, amount: 40.0)
      forecast = balance_forecaster.forecast_balance(to)
      expect(forecast).to be_empty
    end

    it "adds a BalanceForecast for each date transfers occur" do
      first_date = DateTime.current
      second_date = first_date.tomorrow
      FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 1", on: first_date, amount: 20.0)
      FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 2", on: first_date, amount: 20.0)
      FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 3", on: second_date, amount: 20.0)
      FactoryGirl.create(:transfer_daily, :outgoing, user: homer, reference: "transfer 4", on: second_date, amount: 40.0)
      forecast = balance_forecaster.forecast_balance(second_date)
      expect(forecast.count).to eq 2
      expect(forecast.first.value).to eq 40
      expect(forecast[1].value).to eq 20
    end
  end

  describe "#balance_forecast_on" do
    it "returns the balance forecast for a given date" do
      on = DateTime.current + 1.week
      FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 1", on: DateTime.current, amount: 20.0)
      forecast = balance_forecaster.balance_forecast_on(on)
      expect(forecast.value).to eq 160
    end

    it "balance does not change when there are no transfers that apply" do
      on = DateTime.current + 1.week
      forecast = balance_forecaster.balance_forecast_on(on)
      expect(forecast).to be_nil
    end

    it "is nil when `on` is before any transfers" do
      on = DateTime.current
      FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 1", on: DateTime.current.tomorrow, amount: 20.0)
      forecast = balance_forecaster.balance_forecast_on(on)
      expect(forecast).to be_nil
    end

    it "is empty when `on` is in the past" do
      on = DateTime.current - 1.week
      FactoryGirl.create(:transfer_daily, :incoming, user: homer, reference: "transfer 1", on: DateTime.current, amount: 20.0)
      forecast = balance_forecaster.balance_forecast_on(on)
      expect(forecast).to be_nil
    end
  end
end
