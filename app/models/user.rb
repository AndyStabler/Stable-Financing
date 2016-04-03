class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :transfers
  # many balances over time - store them so the user can see what's going on
  has_many :balances

  validates :name, presence: true
  after_create :initialize_balance

  def initialize_balance
    Balance.create(:value => 0.0, :on => Time.zone.now, :user => self)
  end

  def balance_calculator
    @balance_calculator ||= BalanceCalculator.new self
  end

  def balance_forecaster
    @balance_forecaster ||= BalanceForecaster.new self
  end

  def balance_data
    [finance_log, finance_forecast]
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
