require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:homer) do
    FactoryGirl.create(:user, :homer)
  end

  describe "GET show" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in homer
    end

    context "when the format is html" do
      it "should render the html show template" do
        get :show,:id => homer.id
        expect(response).to render_template(:show)
        expect(response.status).to be 200
      end
    end

    context "when the format is csv" do
      it "should render a csv output" do
        get :show, :id => homer.id, :format => "csv"
        expect(response).to render_template :show
        expect(response.content_type).to eq("text/csv")
        expect(response.status).to be 200
      end
    end

    context "when the format is json" do
      it "should return json data" do
        get :show,:id => homer.id, :format => "json"
        expect(response.content_type).to eq("application/json")
        expect(response.status).to be 200
      end
    end

  end
end
