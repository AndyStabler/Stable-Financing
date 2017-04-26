class BalanceForecastsController < ApplicationController

  def show
    forecast_date = DateTime.parse(params[:date])
    Balance::Forecaster.new(current_user).balance_forecast_on forecast_date
    render partial: "show", locals: {thing: "Wuuuut"}
  end
end
