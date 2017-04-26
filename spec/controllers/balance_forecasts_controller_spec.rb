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
    it "returns the balance forecast for the given date" do
      xhr :get, :show, id: homer.id, date: DateTime.current
      expect(response).to render_template "balance_forecasts/_show"
    end
  end
end
