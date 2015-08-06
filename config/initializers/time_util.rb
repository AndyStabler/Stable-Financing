class Time
  def day_s
    self.to_date.to_s(:db)
  end
end