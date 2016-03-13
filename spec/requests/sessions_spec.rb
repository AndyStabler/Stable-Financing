require 'rails_helper'

RSpec.describe "Sessions", type: :request do

  let(:user) { FactoryGirl.create(:user, :homer) }

  describe "sign in" do

    context "with invalid credentials" do

      it "should reload page with error in flash" do
        get new_user_session_path
        post user_session_path, session: { email: "", password: "" }
        expect(response).to render_template('devise/sessions/new')
        expect(flash.alert).to eq "Invalid email or password."
      end
    end

    context "with valid credentials" do
      before :each do
        sign_in
      end

      it "should redirect to users show page" do
        expect(response).to render_template('users/show')
        expect(flash.alert).to be_nil
      end

      it "should redirect to users show when already signed in" do
        get_via_redirect new_user_session_path
        expect(response).to render_template('users/show')
      end
    end
  end

  context "after signing out" do

    before :each do
      sign_in
      sign_out
    end

    it "should redirect to homepage" do
      expect(response).to render_template('home/index')
    end

    it "should not be able to see user page" do
      get_via_redirect user_path user
      expect(response).to render_template('devise/sessions/new')
    end
  end

  context "not signed in" do
    it "should not be able to see user page" do
      get_via_redirect user_path user
      expect(response).to render_template('devise/sessions/new')
    end
  end

  def sign_in
    get new_user_session_path
    post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => user.password
  end

  def sign_out
    delete_via_redirect destroy_user_session_path
  end
end
