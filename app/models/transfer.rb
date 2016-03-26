class Transfer < ActiveRecord::Base

  belongs_to :user

  validates :amount, :user, :on, presence: true
  validates :outgoing, inclusion: [true, false]
  validates :amount, numericality: true

  def forecast(from, to)
    fail NotImplementedError, "Abstract method forecast needs implementing"
  end

end
