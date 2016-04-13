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
      it "should do the thing" do
        get :show
        byebug
        puts response
      end

    end

    context "when the format is csv" do
    end

    context "when the format is json" do
    end
  end
end
