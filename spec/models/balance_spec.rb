require 'rails_helper'

RSpec.describe Balance, type: :model do

  let(:homer) do
    FactoryGirl.create(:user, :homer)
  end

  describe "diff_from_previous_day" do

    context "balance greater than previous day's" do
      it "should be correct positive value" do
        yesterday = FactoryGirl.create(:balance, :yesterday, user: homer, :value => 10.0)
        today = FactoryGirl.create(:balance, :today, user: homer, :value => 20.0)
        expect(today.diff_from_previous_day).to eql(10.0)
      end
    end

    context "balance less than previous day's" do
      it "should be correct negative value" do
        yesterday = FactoryGirl.create(:balance, :yesterday, user: homer, :value => 20.0)
        today = FactoryGirl.create(:balance, :today, user: homer, :value => 10.0)
        expect(today.diff_from_previous_day).to eql(-10.0)
      end
    end

    context "balance equal to previous day's" do
      it "should be 0" do
        yesterday = FactoryGirl.create(:balance, :yesterday, user: homer, :value => 10.0)
        today = FactoryGirl.create(:balance, :today, user: homer, :value => 10.0)
        expect(today.diff_from_previous_day).to eql(0.0)
      end
    end

    context "when there is no balance for the previous day" do
      it "should be 0" do
        expect(homer.balances.last.diff_from_previous_day).to eql(0.0)
      end
    end

  end

  describe "diff_from_previous_balance" do
    context "no previous value" do
      it "should return only balance value" do
        expect(homer.balance.diff_from_previous_balance).to eql(0.0)
      end
    end

    context "balance greater than previous value" do
      it "should be correct positive value" do
        previous = FactoryGirl.create(:balance, :today, user: homer, :value => 10.0)
        current = FactoryGirl.create(:balance, :today, user: homer, :value => 20.0)
        expect(current.diff_from_previous_balance).to eql(10.0)
      end
    end

    context "balance less than previous value" do
      it "should be correct positive value" do
        previous = FactoryGirl.create(:balance, :today, user: homer, :value => 20.0)
        current = FactoryGirl.create(:balance, :today, user: homer, :value => 10.0)
        expect(current.diff_from_previous_balance).to eql(-10.0)
      end
    end

    context "balance equal to previous value" do
      it "should be 0" do
        previous = FactoryGirl.create(:balance, :today, user: homer, :value => 10.0)
        current = FactoryGirl.create(:balance, :today, user: homer, :value => 10.0)
        expect(current.diff_from_previous_balance).to eql(0.0)
      end
    end

    describe "last_of_month?" do
      context "when last of month" do
        it "should be true" do
          balance = FactoryGirl.create(:balance, on: Date.today.end_of_month.to_datetime, user: homer, :value => 10.0)
          expect(balance.last_of_month?).to be true
        end
      end

      context "when first of month" do
        it "should be false" do
          balance = FactoryGirl.create(:balance, on: Date.today.beginning_of_month.to_datetime, user: homer, :value => 10.0)
          expect(balance.last_of_month?).to be false

        end
      end
    end

    describe "month_diff" do
      it "should be 0 when there is only the initial balance" do
        expect(homer.balance.month_diff).to be_zero
      end

      context "when there are no balances for the previous month" do
        before(:each) do
          # get rid of the initial balance of 0 that occurs on the day the user is created
          homer.balances.destroy_all
        end

        it "should calculate the difference correctly" do
          # put the initial balance of 0 back in, but give it a consistent date
          FactoryGirl.create(:balance, on: DateTime.now.beginning_of_month+1.hour, user: homer, :value => 0.0)
          FactoryGirl.create(:balance, on: DateTime.now.beginning_of_month+2.hour, user: homer, :value => 20.0)
          FactoryGirl.create(:balance, on: DateTime.now.beginning_of_month+1.day, user: homer, :value => 50.0)
          FactoryGirl.create(:balance, on: DateTime.now.beginning_of_month+2.days, user: homer, :value => 5.0)
          expected_month_diff = 5.0
          expect(homer.balance.month_diff).to eql expected_month_diff
        end

        context "and there are balances for the next month" do
          it "should calculate the diff and ignore the next month's balances" do
            # put the initial balance of 0 back in, but give it a consistent date
            FactoryGirl.create(:balance, on: DateTime.now.beginning_of_month+1.hour, user: homer, :value => 0.0)
            FactoryGirl.create(:balance, on: DateTime.now.beginning_of_month+2.hours, user: homer, :value => 100.0)
            FactoryGirl.create(:balance, on: DateTime.now.beginning_of_month+1.day, user: homer, :value => 20.0)
            FactoryGirl.create(:balance, on: DateTime.now.end_of_month+1.day, user: homer, :value => 20.0)
            expected_month_diff = 20.0
            expect(homer.balances.all.first.month_diff).to eql expected_month_diff
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
          FactoryGirl.create(:balance, on: DateTime.now.beginning_of_month-1.day, user: homer, :value => 0.0)
          FactoryGirl.create(:balance, on: DateTime.now.beginning_of_month-1.day+1.hour, user: homer, :value => 5.0)
          FactoryGirl.create(:balance, on: DateTime.now.beginning_of_month+1.hour, user: homer, :value => 100.0)
          FactoryGirl.create(:balance, on: DateTime.now.beginning_of_month+1.day, user: homer, :value => 20.0)
          expected_month_diff = 15.0
          expect(homer.balance.month_diff).to eql expected_month_diff
        end

        context "and there are balances for the next month" do
          it "should calculate the diff and ignore the next month's balances" do
            # put the initial balance of 0 back in, but give it a consistent date
            FactoryGirl.create(:balance, on: DateTime.now.beginning_of_month-1.day, user: homer, :value => 0.0)
            FactoryGirl.create(:balance, on: DateTime.now.beginning_of_month-1.day + 1.hour, user: homer, :value => 5.0)
            FactoryGirl.create(:balance, on: DateTime.now.beginning_of_month+1.hour, user: homer, :value => 100.0)
            FactoryGirl.create(:balance, on: DateTime.now.beginning_of_month+1.day, user: homer, :value => 20.0)
            FactoryGirl.create(:balance, on: DateTime.now.end_of_month+1.day, user: homer, :value => 20.0)
            expected_month_diff = 15.0
            expect(homer.balances.all[2].month_diff).to eql expected_month_diff
          end
        end
      end
    end

  end
end

