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

  def create
    @transfer = TransferFactory.build(transfer_type, transfer_params.merge({ user: current_user }))
    if @transfer.save
      @transfer = Transfer.new(:user => current_user)
    end
    render :partial => "users/new_transfer.js.coffee"
  end

  def destroy
    Transfer.find(params[:id]).destroy
    @transfer = Transfer.new(:user => current_user)
    render :partial => "users/new_transfer.js.coffee"
  end

  private

  def transfer_params
    params.require(:transfer).permit(:on, :amount, :user_id, :outgoing, :reference)
  end

  def transfer_type
    params.require(:recurrence)
  end
end
