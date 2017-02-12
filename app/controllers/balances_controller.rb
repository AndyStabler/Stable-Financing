class BalancesController < ApplicationController

  def new
    @balance = Balance.new value: current_user.balance.value
    render partial: "new.js.coffee"
  end

  def index
    respond_to do |format|
      format.json { render json: current_user.balance_data }
      format.csv do
        @balance_log = current_user.balance_log
        @balance_forecast = current_user.balance_forecast
        response.headers["Content-Disposition"] = "attachment; filename=balance_data.csv"
      end
    end
  end

  def create
    @balance = Balance.new({ :user => current_user, :on => Time.zone.now }.merge balance_params)
    @balance.save
    render :partial => "new.js.coffee"
  end

  private

  def balance_params
    params.require(:balance).permit(:value)
  end
end
