class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :transfers

  has_many :balances

  validates :name, presence: true
  after_create :initialize_balance

  def initialize_balance
    Balance.create(:value => 0.0, :on => Time.zone.now, :user => self)
  end

  def transfer_calculator
    @transfer_calculator ||= TransferCalculator.new self
  end

  def balance_data
    [balance_log, balance_forecast]
  end

  def balance_log
    bals = balances.order :on
    return [] unless bals.any?
    from = bals.first.on
    to = bals.last.on
    BalanceCalculator.new(balances).balance_log(from, to).sort_by(&:on)
  end

  def balance_forecast
    trans = transfers.order :on
    return [] unless trans.any?
    to = trans.last.on.to_date+1.year
    BalanceForecaster.new(self).forecast_balance(to).sort_by(&:on)
  end

  def balance
    balances.order(:on).last
  end

end
