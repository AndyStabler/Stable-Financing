class TransfersController < ApplicationController

  def index
    transfer_date = params[:transfer]
    if (transfer_date)
      transfer_date = Util::Date.safe_date_parse(transfer_date)
      transfers = current_user.transfer_calculator.transfers_occurring_on(transfer_date)
    else
      transfers = current_user.transfers
    end
    render json: transfers.as_json(methods: :recurrence)
  end

  def destroy
    Transfer.find(params[:id]).destroy
    @transfer = Transfer.new(:user => current_user)
    render :partial => "users/new_transfer.js.coffee"
  end
end
