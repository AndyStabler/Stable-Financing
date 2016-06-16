require 'rails_helper'

RSpec.describe Util::DateTime do
  it "should be true" do
    from = Date.parse("2016-06-30")
    to = Date.parse("2017-02-28")
    expect(Util::DateTime.months_between_inclusive(from, to)).to be 9
  end
end
