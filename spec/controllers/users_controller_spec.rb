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

  describe "POST new_transfer" do
    context "with an invalid transfer" do
      it "should pass the erroneous transfer back" do
        transfer = FactoryGirl.build(:transfer_daily, :on => nil, :user => homer)
        recurrence = TransferDaily::RECURRENCE
        post :new_transfer,
          {
            :id => homer.id,
            :transfer => transfer.attributes,
            :recurrence => recurrence
          }, :xhr => true
        expect(assigns(:transfer).attributes).to eq transfer.attributes
        check_status response
      end
    end

    it "should create a new transfer" do
      transfer = FactoryGirl.build(:transfer_daily, :user => homer)
      recurrence = TransferDaily::RECURRENCE
      post :new_transfer,
        {
          :id => homer.id,
          :transfer => transfer.attributes,
          :recurrence => recurrence
        }, :xhr => true
      expect(assigns(:transfer).new_record?).to be true
      expect(assigns(:transfer).attributes).to_not eq transfer.attributes
      check_status response
    end
  end

  describe "POST new_balance" do
    context "when the balance is valid" do
      it "should save the balance" do
        balance = FactoryGirl.build(:balance, :today, :value => 20.00)
        expect(homer.balance.value).to_not eq balance.value
        post :new_balance, :id => homer.id, :balance => balance.attributes, :xhr => true
        expect(assigns(:balance).persisted?).to be true
        expect(homer.balance.value).to eq balance.value
        check_status response
      end
    end

    context "when the balance is invalid" do
      it "should not save the balance" do
        balance = FactoryGirl.build(:balance, :today, :value => "")
        post :new_balance, :id => homer.id, :balance => balance.attributes, :xhr => true
        expect(assigns(:balance).new_record?).to be true
        expect(homer.balance.value).to_not eq balance.value
        expect(assigns(:balance).errors.present?).to be true
        check_status response
      end
    end
  end

  def check_status(response, status = 200)
    expect(response.status).to eq status
  end

end
