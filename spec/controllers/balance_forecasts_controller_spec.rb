require "rails_helper"

RSpec.describe BalanceForecastsController, type: :controller do
  let(:homer) do
    FactoryGirl.create(:user, :homer)
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in homer
  end

  describe "#show" do
    it "renders the balance forecast table" do
      FactoryGirl.create(:transfer_daily, user: homer)
      xhr :get, :show, id: homer.id, date: 1.week.from_now
      expect(response).to render_template "balance_forecasts/_show"
    end

    it "renders the blank slate when the date is invalid" do
      xhr :get, :show, id: homer.id, date: DateTime.yesterday
      expect(response).to render_template "balance_forecasts/_blank_slate"
    end
  end
end
