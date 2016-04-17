class TransferMonthly < Transfer

  def forecast(from = nil, to)
    transfer_occurences = []
    from ||= on.to_date

    return transfer_occurences unless to >= from && on.to_date <= to
    transfer_date = on.to_date

    months = Util::DateTime.months_between_inclusive(transfer_date, to)
    months.times do |mt|
      new_transfer_date = transfer_date + mt.months
      next if new_transfer_date < from
      transfer_occurences << new_transfer_date
    end
    transfer_occurences
  end

  def recurrence
    "Monthly"
  end
end
