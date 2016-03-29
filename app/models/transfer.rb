class Transfer < ActiveRecord::Base

  belongs_to :user

  validates :amount, :user, :on, presence: true
  validates :outgoing, inclusion: [true, false]
  validates :amount, numericality: true

  def difference
    outgoing ? -amount : amount
  end

  def forecast(from = nil, to)
    fail NotImplementedError, "Abstract method forecast needs implementing"
  end

end
