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



  end
end

