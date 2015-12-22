class User < ActiveRecord::Base

  extend FriendlyId

  friendly_id :username

  has_many :transfers
  # many balances over time - store them so the user can see what's going on
  has_many :balances

  validates_format_of :username, with: /\A[a-z0-9\-_]+\z/i, length: { maximum: 50 }
  validates_format_of :email, with: /\A\S+@.+\.\S+\z/
  validates_uniqueness_of :username
  validates :name, :username, :email, :password, presence: true
  validates :email, confirmation: true, uniqueness: { case_sensitive: false }
  before_save { self.email = email.downcase }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  attr_accessor :remember_token

  def number_cruncher
    @number_cruncher ||= NumberCruncher.new self
  end

  def incoming
    transfers.where(outgoing: false)
  end

  def outgoing
    transfers.where(outgoing: true)
  end

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

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end
end
