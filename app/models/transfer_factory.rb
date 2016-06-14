class TransferFactory

  RECURRENCES = [
    TransferDaily::RECURRENCE,
    TransferWeekly::RECURRENCE,
    TransferMonthly::RECURRENCE,
    TransferNoRecurrence::RECURRENCE
  ]

  def self.build(recurrence, attributes)
    case recurrence
    when TransferDaily::RECURRENCE
      TransferDaily.new(attributes)
    when TransferWeekly::RECURRENCE
      TransferWeekly.new(attributes)
    when TransferMonthly::RECURRENCE
      TransferMonthly.new(attributes)
    when TransferNoRecurrence::RECURRENCE
      TransferNoRecurrence.new(attributes)
    else
      Transfer.new(attributes)
    end
  end
end
