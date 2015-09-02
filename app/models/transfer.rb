class Transfer < ActiveRecord::Base
  belongs_to :user

  enum recurrence: [:no, :daily, :weekly, :monthly]

  validates :amount, :user, :on, :recurrence, presence: true
  validates :outgoing, inclusion: [true, false]
  validates :amount, numericality: true

end