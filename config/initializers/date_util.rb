class Date
  def months_between(in_date)
    (in_date.year - self.year) * 12 + in_date.month - self.month - (in_date.day >= self.day ? 0 : 1)
  end
end
