ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user, options = {})
    password = options[:password] || "pwd"
    remember_me = options[:remember_me] || '1'
    if integration_test?
        post login_path, :session => { :email => user.email,
                                        :password => password,
                                        :remember_me => remember_me }
    else
        session[:user_id] = user.id
    end
  end

  # Get a balance forecast for this user
  #
  # Predicts future bank balances based on the incomings/outgoings
  # returns an array FinanceItems
  def finance_forecast user
    trans = user.transfers.order(:on)
    return [] unless trans.any?
    from = trans.first.on.to_date
    to = trans.last.on.to_date+1.year
    NumberCruncher.new(user).balance_forecast_between(from, to).sort_by(&:on)
  end

  # Get a log of balances for this user
  #
  # Returns an array of FinanceItems based on the user's logged balances
  def finance_log user
    bals = user.balances.order(:on)
    return [] unless bals.any?
    from = bals.first.on
    to = bals.last.on
    NumberCruncher.new(user).finance_log_between(from, to).sort_by(&:on)
  end


  private

    def integration_test?
        defined?(post_via_redirect)
    end
end
