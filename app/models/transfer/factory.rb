class Transfer::Factory

  RECURRENCES = [
    Transfer::Daily::RECURRENCE,
    Transfer::Weekly::RECURRENCE,
    Transfer::Monthly::RECURRENCE,
    Transfer::NoRecurrence::RECURRENCE
  ]

  def self.build(recurrence, attributes)
    case recurrence
    when Transfer::Daily::RECURRENCE
      Transfer::Daily.new(attributes)
    when Transfer::Weekly::RECURRENCE
      Transfer::Weekly.new(attributes)
    when Transfer::Monthly::RECURRENCE
      Transfer::Monthly.new(attributes)
    when Transfer::NoRecurrence::RECURRENCE
      Transfer::NoRecurrence.new(attributes)
    else
      Transfer.new(attributes)
    end
  end
end
