require 'rails_helper'

RSpec.describe Util::Date do

  describe ".safe_date_parse" do
    context "valid date string" do
      it "should return a Date object" do
        date = Util::Date.safe_date_parse("2016-08-01")
        expect(date).to eq Date.parse("2016-08-1")
        expect(date).to_not eq Date.current
      end
    end

    context "invalid date string" do
      context "when a default date is passed in" do
        it "should return the default date" do
          date = Util::Date.safe_date_parse("invalid date here", Date.current)
          expect(date).to eq Date.today
        end
      end

      context "when a default date is not passed in" do
        it "should return today's date" do
          default_date = Date.current - 1.day
          date = Util::Date.safe_date_parse("invalid date here", default_date)
          expect(date).to eq default_date
        end
      end
    end
  end
end
