class Transfer < ActiveRecord::Base

  belongs_to :user

  validates :amount, :user, :on, presence: true
  validates :outgoing, inclusion: [true, false]
  validates :amount, numericality: true

  scope :outgoing, ->(user) { where("user_id = ? AND outgoing = ?", user.id, true) }
  scope :incoming, ->(user) { where("user_id = ? AND outgoing = ?", user.id, false) }

  def difference
    outgoing ? -amount : amount
  end

  def forecast(from = nil, to)
    fail NotImplementedError, "Abstract method forecast needs implementing"
  end

  def recurrence
    self.class::RECURRENCE
  end

end
