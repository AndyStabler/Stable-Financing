class TransferNoRecurrence < Transfer

  def forecast(from = nil, to)
    from ||= on.to_date
    (from..to).include?(on.to_date) ? [self.on.to_date] : []
  end

  def self.recurrence
    "None".freeze
  end
end
