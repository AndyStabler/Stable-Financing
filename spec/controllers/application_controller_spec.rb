require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  describe "#not_found" do
    it "should raise a routing error" do
      expect{controller.not_found}.to raise_error ActionController::RoutingError
    end
  end
end
