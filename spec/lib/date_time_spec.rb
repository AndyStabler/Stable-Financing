require 'rails_helper'

RSpec.describe Util::DateTime do


  describe "#months_between_inclusive" do
    context "when the to day is less than the from day" do

      context "and the to day is last day of the month" do
        # 31 Aug - 30 Sep
        # 29/30/31 Jan - 28 Feb
        # etc.
        it "should round up and include the last month" do
          from = Date.parse("2016-01-30")
          to = Date.parse("2016-02-29")
          expect(Util::DateTime.months_between_inclusive(from, to)).to be 2
        end
      end

      context "and the to day is not the last day of the month" do
        # 26 Aug - 24 Sep
        it "should not include the last month" do
          from = Date.parse("2016-08-26")
          to = Date.parse("2016-09-25")
          expect(Util::DateTime.months_between_inclusive(from, to)).to be 1
        end
      end
    end

    context "when the to day is equal to the from day" do
      # 31 July - 31 Aug
      # 20 March - 20 May
      it "should include the last month" do
        from = Date.parse("2016-07-31")
        to = Date.parse("2016-08-31")
        expect(Util::DateTime.months_between_inclusive(from, to)).to be 2
      end
    end

    context "when the to day is greater than the from day" do
      # 25 Aug - 28 Sep
      context "when the month has not progressed" do
        it "should not include the last month" do
          from = Date.parse("2016-08-25")
          to = Date.parse("2016-09-28")
          expect(Util::DateTime.months_between_inclusive(from, to)).to be 2
        end
      end

      # 25 Aug - 5 Oct
      context "when the month has progressed" do
        it "should not include the last month" do
          from = Date.parse("2016-08-25")
          to = Date.parse("2016-10-05")
          expect(Util::DateTime.months_between_inclusive(from, to)).to be 2
        end
      end
    end
  end
end
