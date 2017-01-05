class TransfersController < ApplicationController
  before_action :set_user

  def index
    transfer_date = params[:transfer]
    if (transfer_date)
      transfer_date = Util::Date.safe_date_parse(transfer_date)
      transfers = @user.transfer_calculator.transfers_occurring_on(transfer_date)
    else
      transfers = @user.transfers
    end
    render json: transfers.as_json(methods: :recurrence)
  end

  private

  def set_user
    not_found unless current_user.id.to_s == params[:id].to_s
    @user = current_user
  end
end
