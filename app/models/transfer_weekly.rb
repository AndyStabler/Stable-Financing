class TransferWeekly < Transfer

  def forecast(from = nil, to)
    transfer_occurences = []
    from ||= on.to_date

    return transfer_occurences unless to >= from && on.to_date <= to
    transfer_date = on.to_date

    weeks = Util::DateTime.weeks_between_inclusive(transfer_date, to)
    weeks.times do |wk|
      new_transfer_date = transfer_date + wk.weeks
      next if new_transfer_date < from
      transfer_occurences << new_transfer_date
    end
    transfer_occurences
  end
end
