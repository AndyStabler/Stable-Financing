class BalanceForecastsController < ApplicationController

  def show
    forecast_date = DateTime.parse(params[:date])
    forecast = Balance::Forecaster.new(current_user).balance_forecast_on forecast_date
    if forecast
      render partial: "show", locals: {forecast: forecast}
    else
      render partial: "blank_slate"
    end
  end
end
