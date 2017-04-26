require "rails_helper"

RSpec.describe BalanceForecastsController, type: :controller do
  before(:each) do
    homer = FactoryGirl.create(:user, :homer)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in homer
  end

  describe "#show" do
    it "returns the balance forecast for the given date" do
      xhr :get, :show, id: DateTime.current
      expect(response).to render_template "_show.js"
    end
  end
end
