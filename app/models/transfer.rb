class Transfer < ActiveRecord::Base

  belongs_to :user

  validates :amount, :user, :on, :recurrence, presence: true
  validates :outgoing, inclusion: [true, false]
  validates :amount, numericality: true

  def forecast(from, to)
    fail NotImplementedError, "Abstract method forecast needs implementing"
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
          date_of_transfer = on + day_to_add.days
          next if date_of_transfer < start_date
          (date_to_transfers[date_of_transfer]||=[]) << trans
        end
      elsif recurrence == :weekly && on <= end_date
        weeks = (((end_date - on) / 7).to_i + 1)
        weeks.times do |wk|
          date_of_transfer = on + wk.weeks
          next if date_of_transfer < start_date
          (date_to_transfers[date_of_transfer]||=[]) << trans
        end
      elsif recurrence == :monthly && on <= end_date
        months = (Util::DateTimeUtil.months_between(on, end_date)).to_i + 1
        months.times do |mt|
          date_of_transfer = on + mt.months
          next if date_of_transfer < start_date
          (date_to_transfers[date_of_transfer]||=[]) << trans
        end
      end
    end
    date_to_transfers
  end

end
