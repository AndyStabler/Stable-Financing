class TransferDaily < Transfer

  def forecast(from = nil, to)
    transfer_occurences = []
    from ||= on.to_date

    return transfer_occurences unless to >= from && on.to_date <= to
    transfer_date = on.to_date

    days = Util::DateTime.days_between_inclusive(transfer_date, to)
    days.times do |day_to_add|
      new_transfer_date = transfer_date + day_to_add.days
      next if new_transfer_date < from
      transfer_occurences << new_transfer_date
    end
    transfer_occurences
  end

end
