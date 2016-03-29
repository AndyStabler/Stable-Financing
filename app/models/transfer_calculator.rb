class TransferCalculator

  def initialize(user)
    @user = user
  end

  def all_transfers_on(date)
  end

  def incoming
    @incoming ||= @user.transfers.select { |tr| !tr.outgoing }
  end

  def outgoing
    @outgoing ||= @user.transfers.select { |tr| tr.outgoing }
  end

  def total_incoming
    @total_incoming ||= incoming.map(&:amount).inject(:+) || 0.0
  end

  def total_outgoing
    @total_outgoing ||= outgoing.map(&:amount).inject(:+) || 0.0
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

  # Public: forecasts every transfer
  #
  # from  - used to get transfers occurring on or after this date (optional)
  #   if this value is not supplied, the date for the oldest transfer will be used
  # to    - the date up to which transfer dates will be calculated (inclusive)
  #
  # returns an array of dates transfers are registered to occur on between from and to (inclusive)
  def all_transfer_dates(from = nil, to)
    @user.transfers.map { |transfer| transfer.forecast(from, to) }.flatten.uniq
  end

  def transfers_occurring_on(date)
    @user.transfers.select { | transfer| transfer.forecast(date).include? date }
  end

  def self.total_difference(transfers)
    transfers.map { |transfer| transfer.difference }.inject :+
  end
end
