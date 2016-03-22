class TransferCalculator

  def initialize(transfers)
    @transfers = transfers
  end

  def all_transfers_on(date)
  end

  def incoming
    @incoming ||= @transfers.select { |tr| !tr.outgoing }
  end

  def outgoing
    @outgoing ||= @transfers.select { |tr| tr.outgoing }
  end

  def total_incoming
    @total_incoming ||= incoming.map(&:amount).inject(:+) || 0.0
  end

  def total_outgoing
    @total_outgoing ||= outgoing.map(&:amaount).inject(:+) || 0.0
  end

  # Public: all transfers
  #
  # from  - used to get transfers occurring on or after this date (optional)
  #   if this value is not supplied, the date for the oldest transfer will be used
  # to    - the date up to which transfers will be calculated (inclusive)
  #
  # returns an array of transfers occuring between from and to (inclusive)
  def all_transfers(from = nil, to)
  end

  # Public: every date that a transfer is registered to occur on
  #
  # from  - used to get transfers occurring on or after this date (optional)
  #   if this value is not supplied, the date for the oldest transfer will be used
  # to    - the date up to which transfer dates will be calculated (inclusive)
  #
  # returns an array of dates transfers are registered to occur on between from and to (inclusive)
  def all_transfer_dates(from = nil, to)
  end

end
