class TransferFactory

  DAILY = "daily"
  WEEKLY = "weekly"
  MONTHLY = "monthly"
  NONE = "none"
  TYPES = [DAILY, WEEKLY, MONTHLY, NONE]

  def self.build(recurrence, attributes)
    case recurrence
    when DAILY
      TransferDaily.new(attributes)
    when WEEKLY
      TransferDaily.new(attributes)
    when MONTHLY
      TransferMonthly.new(attributes)
    when NONE
      TransferNoRecurrence.new(attributes)
    else
      Transfer.new(attributes)
    end
  end
end
