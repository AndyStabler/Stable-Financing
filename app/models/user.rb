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

  def number_cruncher
    @number_cruncher ||= NumberCruncher.new self
  end

  scope :incoming, -> { where :outoing => false }
  scope :outgoing, -> { where :outoing => true }

  def finance_data
    bal_log = balance_log
    bal_forecast = balance_forecast
    bal_log.concat(bal_forecast)
  end

  def finance_log
    bals = balances.order(:on)
    return [] unless bals.any?
    from = bals.first.on
    to = bals.last.on
    number_cruncher.finance_log_between(from, to).sort_by(&:on)
  end

  def finance_forecast
    trans = transfers.order(:on)
    return [] unless trans.any?
    from = trans.first.on.to_date
    to = trans.last.on.to_date+1.year
    number_cruncher.balance_forecast_between(from, to).sort_by(&:on)
  end

  def balance
    balances.order(:on).last
  end

end
