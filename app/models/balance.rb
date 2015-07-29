class Balance < ActiveRecord::Base
  belongs_to :transfer

  delegate :user, to: :transfer
end
