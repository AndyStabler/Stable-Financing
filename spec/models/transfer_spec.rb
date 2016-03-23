require 'rails_helper'

RSpec.describe Transfer, type: :model do

  let(:homer) do
    FactoryGirl.create(:user, :homer)
  end

  describe "#forecast" do
    it "should fail" do
      t = FactoryGirl.create(:transfer, :incoming, user: homer, reference: "transfer 1", on: DateTime.now-10.days, amount: 20)
      expect{t.forecast(Date.yesterday, Date.tomorrow)}.to raise_error(NotImplementedError)
    end
  end

end
