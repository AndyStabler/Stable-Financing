class TransferNoRecurrence < Transfer

  def forecast(from = nil, to)
    from ||= on.to_date
    (from..to).include?(on.to_date) ? [self] : []
  end

  def recurrence
    "None".freeze
  end
end
