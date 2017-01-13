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

  describe "#month_diff" do
    it "should be 0 when there is only the initial balance" do
      expect(balance_calculator.month_diff(homer.balance.on)).to be_zero
    end

    context "when there are no balances for the previous month" do
      before(:each) do
        # get rid of the initial balance of 0 that occurs on the day the user is created
        homer.balances.destroy_all
      end

      it "should calculate the difference correctly" do
        # put the initial balance of 0 back in, but give it a consistent date
        FactoryGirl.create(:balance, on: DateTime.current.beginning_of_month+1.hour, user: homer, :value => 0.0)
        FactoryGirl.create(:balance, on: DateTime.current.beginning_of_month+2.hour, user: homer, :value => 20.0)
        FactoryGirl.create(:balance, on: DateTime.current.beginning_of_month+1.day, user: homer, :value => 50.0)
        FactoryGirl.create(:balance, on: DateTime.current.beginning_of_month+2.days, user: homer, :value => 5.0)
        expected_month_diff = 5.0
        expect(balance_calculator.month_diff(homer.balance.on)).to eql expected_month_diff
      end

      context "and there are balances for the next month" do
        it "should calculate the diff and ignore the next month's balances" do
          # put the initial balance of 0 back in, but give it a consistent date
          FactoryGirl.create(:balance, on: DateTime.current.beginning_of_month+1.hour, user: homer, :value => 0.0)
          FactoryGirl.create(:balance, on: DateTime.current.beginning_of_month+2.hours, user: homer, :value => 100.0)
          FactoryGirl.create(:balance, on: DateTime.current.beginning_of_month+1.day, user: homer, :value => 20.0)
          FactoryGirl.create(:balance, on: DateTime.current.end_of_month+1.day, user: homer, :value => 20.0)
          expected_month_diff = 20.0
          expect(balance_calculator.month_diff(homer.balances.all.first.on)).to eql expected_month_diff
        end
      end
    end

    context "when there are balances for previous month" do
      before(:each) do
        # get rid of the initial balance of 0 that occurs on the day the user is created
        homer.balances.destroy_all
      end

      it "should calculate the diff based on last balance of previous month" do
        # put the initial balance of 0 back in, but give it a consistent date
        FactoryGirl.create(:balance, on: DateTime.current.beginning_of_month-1.day, user: homer, :value => 0.0)
        FactoryGirl.create(:balance, on: DateTime.current.beginning_of_month-1.day+3.hour, user: homer, :value => 5.0)
        first = FactoryGirl.create(:balance, on: DateTime.current.beginning_of_month+1.hour, user: homer, :value => 100.0)
        FactoryGirl.create(:balance, on: DateTime.current.beginning_of_month+1.day, user: homer, :value => 20.0)
        expected_month_diff = 15.0
        expect(balance_calculator.month_diff(first.on)).to eql expected_month_diff
      end

      context "and there are balances for the next month" do
        it "should calculate the diff and ignore the next month's balances" do
          # put the initial balance of 0 back in, but give it a consistent date
          FactoryGirl.create(:balance, on: DateTime.current.beginning_of_month-1.day, user: homer, :value => 0.0)
          FactoryGirl.create(:balance, on: DateTime.current.beginning_of_month-1.day + 3.hour, user: homer, :value => 5.0)
          FactoryGirl.create(:balance, on: DateTime.current.beginning_of_month+1.hour, user: homer, :value => 100.0)
          FactoryGirl.create(:balance, on: DateTime.current.beginning_of_month+1.day, user: homer, :value => 20.0)
          FactoryGirl.create(:balance, on: DateTime.current.end_of_month+1.day, user: homer, :value => 20.0)
          expected_month_diff = 15.0
          expect(balance_calculator.month_diff(homer.balances.all[2].on)).to eql expected_month_diff
        end
      end
    end
  end

end
