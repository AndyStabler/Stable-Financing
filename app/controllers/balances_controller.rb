class BalancesController < ApplicationController

  def create
    @balance = Balance.new({ :user => current_user, :on => Time.zone.now }.merge balance_params)
    @balance.save
    render :partial => "new_balance.js.coffee"
  end

  private

  def balance_params
    params.require(:balance).permit(:value)
  end
end
