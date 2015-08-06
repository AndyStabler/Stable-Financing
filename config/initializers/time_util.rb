class Time
  def day_of
    self.to_date.to_s(:db)
  end
end