class BalanceForecastsController < ApplicationController

  def show
    forecast_date = DateTime.parse(params[:id])
    Balance::Forecaster.new(current_user).balance_forecast_on forecast_date
    render partial: "show.js"
  end
end
