require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:homer) do
    FactoryGirl.create(:user, :homer)
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in homer
  end

  describe "GET show" do

    context "when the format is html" do
      it "should render the html show template" do
        get :show,:id => homer.id
        expect(response).to render_template(:show)
        check_status response
      end
    end

    context "when the format is csv" do
      it "should render a csv output" do
        get :show, :id => homer.id, :format => "csv"
        expect(response).to render_template :show
        expect(response.content_type).to eq("text/csv")
        check_status response
      end
    end

    context "when the format is json" do
      it "should return json data" do
        get :show, :id => homer.id, :format => "json"
        expect(response.content_type).to eq("application/json")
        check_status response
      end
    end
  end

  describe "GET new" do
    it "should create a new user" do
      get :new
      expect(assigns(:user).new_record?).to be true
      check_status response
    end
  end

  def check_status(response, status = 200)
    expect(response.status).to eq status
  end

end
