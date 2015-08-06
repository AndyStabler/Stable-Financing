class Transfer < ActiveRecord::Base
  belongs_to :user

  enum recurrence: [:no, :daily, :weekly, :monthly]

end
