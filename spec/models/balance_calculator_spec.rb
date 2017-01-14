require 'rails_helper'

RSpec.describe BalanceCalculator, type: :model do

  let(:homer) do
    FactoryGirl.create(:user, :homer)
  end

  let(:balance_calculator) do
    BalanceCalculator.new(homer.balances.all)
  end

  describe "#balance_log" do
    context "when there are multiple balances per day" do
      it "shows the last balance of the day" do
        first_time = DateTime.current.beginning_of_day+1.hour
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
