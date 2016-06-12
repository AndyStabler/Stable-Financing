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

  describe "GET transfers" do

    let!(:transfers) do
      [
        FactoryGirl.create(:transfer_weekly, :user => homer),
        FactoryGirl.create(:transfer_monthly, :user => homer)
      ]
    end

    context "when a transfer date is in the params" do
      it "should only return transfers occurring on that date" do
        date = DateTime.current
        allow(homer.transfer_calculator).to receive(:transfers_occurring_on) { transfers }
        get :transfers, :id => homer.id, :transfer => date.to_s, :format => "json", :xhr => true
        expect(response.content_type).to eq("application/json")
        # to_json is the json_string, not the JSON object - dandy!
        expect(response.body).to eq transfers.to_json(:methods => :recurrence)
        check_status response
      end
    end

    context "when no data is sent in the params" do
      it "should return all transfers" do
        homer.transfers = transfers
        get :transfers, :id => homer.id, :format => "json", :xhr => true
        expect(response.body).to eq transfers.to_json(:methods => :recurrence)
        check_status response
      end
    end
  end

  def check_status(response, status = 200)
    expect(response.status).to eq status
  end

end
