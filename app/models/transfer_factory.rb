class TransferFactory

  RECURRENCES = [
    TransferDaily.recurrence,
    TransferWeekly.recurrence,
    TransferMonthly.recurrence,
    TransferNoRecurrence.recurrence
  ]

  def self.build(recurrence, attributes)
    case recurrence
    when TransferDaily.recurrence
      TransferDaily.new(attributes)
    when TransferWeekly.recurrence
      TransferWeekly.new(attributes)
    when TransferMonthly.recurrence
      TransferMonthly.new(attributes)
    when TransferNoRecurrence.recurrence
      TransferNoRecurrence.new(attributes)
    else
      Transfer.new(attributes)
    end
  end
end
