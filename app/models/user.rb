class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :transfers
  # many balances over time - store them so the user can see what's going on
  has_many :balances

  validates_format_of :email, with: /\A\S+@.+\.\S+\z/
  validates :name, :email, :password, presence: true
  validates :email, confirmation: true, uniqueness: { case_sensitive: false }
  before_save { self.email = email.downcase }
  after_create :initialize_balance
  validates :password, presence: true, length: { minimum: 6 }

  def initialize_balance
    initial_balance = Balance.new(:value => 0.0, :on => Time.zone.now, :user => self)
    initial_balance.save
  end

  def balance_calculator
    @balance_calculator ||= BalanceCalculator.new self
  end

  def balance_forecaster
    @balance_forecaster ||= BalanceForecaster.new self
  end

  def finance_data
    bal_log = balance_log
    bal_forecast = balance_forecast
    bal_log.concat(bal_forecast)
  end

  def balance_data
    log = finance_log.map { |balance| {:date => balance.on.to_date, :value => balance.value} }
    forecast = finance_forecast.map { |forecast| {:date => forecast.date, :value => forecast.balance} }
    log+forecast
  end

  def finance_log
    bals = balances.order(:on)
    return [] unless bals.any?
    from = bals.first.on
    to = bals.last.on
    balance_calculator.balance_log(from, to).sort_by(&:on)
  end

  def finance_forecast
    trans = transfers.order(:on)
    return [] unless trans.any?
    to = trans.last.on.to_date+1.year
    balance_forecaster.forecast_balance(to).sort_by(&:date)
  end

  def balance
    balances.order(:on).last
  end

end
