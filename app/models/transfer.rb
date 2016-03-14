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

  # Group transfers by the day they will take place on
  # A transfer can be registered once, but may have a recurrence that means it will occur repeatedly (every mnonth say)
  #
  # Returns a hash mappping dates to the transfers that occur
  def self.group_transfers_by_date transfers, start_date, end_date
    return {} unless transfers.any? && end_date >= start_date

    date_to_transfers = {}

    transfers.each do |trans|
      on = trans.on.to_date
      recurrence = trans.recurrence.to_sym
      if recurrence == :no && (on >= start_date && on <= end_date)
        (date_to_transfers[on]||=[]) << trans
      elsif recurrence == :daily && on <= end_date
        days = (end_date - on).to_i + 1
        days.times do |day_to_add|
          (date_to_transfers[on + day_to_add.days]||=[]) << trans
        end
      elsif recurrence == :weekly && on <= end_date
        weeks = (((end_date - on) / 7).to_i + 1)
        weeks.times do |wk|
          (date_to_transfers[on + wk.weeks]||=[]) << trans
        end
      elsif recurrence == :monthly && on <= end_date
        months = (on.months_between(end_date)).to_i + 1
        months.times do |mt|
          (date_to_transfers[on + mt.months]||=[]) << trans
        end
      end
    end
    date_to_transfers
  end

end
