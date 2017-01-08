require "rails_helper"
RSpec.describe TransfersController, type: :controller do

  let(:homer) do
    FactoryGirl.create(:user, :homer)
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in homer
  end

  describe "GET index" do

    let!(:transfers) do
      [
        FactoryGirl.create(:transfer_weekly, :user => homer),
        FactoryGirl.create(:transfer_monthly, :user => homer)
      ]
    end

    context "when a transfer date is in the params" do

      it "should use the current date when the date string is mangled" do
        date = "An invalid date!"
        allow(homer.transfer_calculator).to receive(:transfers_occurring_on) { transfers }
        get :index, :transfer => date, :format => "json", :xhr => true
        expect(response.content_type).to eq("application/json")
        # to_json is the json_string, not the JSON object - dandy!
        expect(response.body).to eq transfers.to_json(:methods => :recurrence)
        expect(response).to be_success
      end

      it "should only return transfers occurring on that date" do
        date = DateTime.current
        allow(homer.transfer_calculator).to receive(:transfers_occurring_on) { transfers }
        get :index, :transfer => date.to_s, :format => "json", :xhr => true
        expect(response.content_type).to eq("application/json")
        expect(response.body).to eq transfers.to_json(:methods => :recurrence)
        expect(response).to be_success
      end

      it "should include the transfer recurrence in the response" do
        date = DateTime.current
        allow(homer.transfer_calculator).to receive(:transfers_occurring_on) { transfers }
        get :index, :transfer => date.to_s, :format => "json", :xhr => true
        expect(response.content_type).to eq("application/json")
        json_response = JSON.parse(response.body).first
        expect(json_response).to have_key "recurrence"
      end
    end

    context "when no data is sent in the params" do
      it "should return all transfers" do
        homer.transfers = transfers
        get :index, :format => "json", :xhr => true
        expect(response.body).to eq transfers.to_json(:methods => :recurrence)
        expect(response).to be_success
      end
    end
  end

  describe "POST create_transfer" do
    context "with an invalid transfer" do
      it "should pass the erroneous transfer back" do
        transfer = FactoryGirl.build(:transfer_daily, :on => nil, :user => homer)
        recurrence = TransferDaily::RECURRENCE
        post :create,
          {
            :id => homer.id,
            :transfer => transfer.attributes,
            :recurrence => recurrence
          }, :xhr => true
        expect(assigns(:transfer).attributes).to eq transfer.attributes
        expect(response).to be_success
      end
    end

    it "should create a new transfer" do
      transfer = FactoryGirl.build(:transfer_daily, :user => homer)
      recurrence = TransferDaily::RECURRENCE
      post :create,
        {
          :id => homer.id,
          :transfer => transfer.attributes,
          :recurrence => recurrence
        }, :xhr => true
      expect(assigns(:transfer).new_record?).to be true
      expect(assigns(:transfer).attributes).to_not eq transfer.attributes
      expect(response).to be_success
    end
  end

  describe "POST destroy" do
    it "deletes the transfer" do
      transfer = FactoryGirl.create(:transfer_weekly, :user => homer)
      expect {
        post :destroy, id: transfer.id
      }.to change(Transfer, :count).by(-1)
    end
  end
end
