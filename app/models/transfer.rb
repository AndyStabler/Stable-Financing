class Transfer < ActiveRecord::Base
  belongs_to :user

  enum recurrence: [:no, :daily, :weekly, :monthly]

  validates :amount, :user, :on, :recurrence, presence: true
  validates :outgoing, inclusion: [true, false]
  validates :amount, numericality: true


  def self.all_incoming(transfers)
    transfers.select { |tr| !tr.outgoing }
  end

  def self.sum_incoming(transfers)
    all_incoming(transfers).map(&:amount).inject(:+) || 0.0
  end

  def self.all_outgoing(transfers)
    transfers.select { |tr| tr.outgoing }
  end

  def self.sum_outgoing(transfers)
    all_outgoing(transfers).map(&:amount).inject(:+) || 0.0
  end
end
