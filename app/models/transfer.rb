class Transfer < ActiveRecord::Base
  belongs_to :user
  has_many :balances

  enum recurrence: [:no, :daily, :weekly, :monthly]


end
