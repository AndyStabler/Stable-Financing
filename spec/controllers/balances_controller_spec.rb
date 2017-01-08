require "rails_helper"

RSpec.describe BalancesController, type: :controller do

  let(:homer) do
    FactoryGirl.create(:user, :homer)
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in homer
  end

  describe "POST create" do
    context "when the balance is valid" do
      it "should save the balance" do
        balance = FactoryGirl.build(:balance, :today, :value => 20.00)
        expect(homer.balance.value).to_not eq balance.value
        post :create, :id => homer.id, :balance => balance.attributes, :xhr => true
        expect(assigns(:balance).persisted?).to be true
        expect(homer.balance.value).to eq balance.value
        expect(response).to be_success
      end
    end

    context "when the balance is invalid" do
      it "should not save the balance" do
        balance = FactoryGirl.build(:balance, :today, :value => "")
        post :create, :id => homer.id, :balance => balance.attributes, :xhr => true
        expect(assigns(:balance).new_record?).to be true
        expect(homer.balance.value).to_not eq balance.value
        expect(assigns(:balance).errors.present?).to be true
        expect(response).to be_success
      end
    end
  end
end
