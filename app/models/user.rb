class User < ActiveRecord::Base

  has_many :outgoing, class_name: 'Transaction', foreign_key: 'transaction_id'
  has_many :incoming, class_name: 'Transaction', foreign_key: 'transaction_id'
end
