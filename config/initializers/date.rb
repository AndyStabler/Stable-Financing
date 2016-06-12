class Date

  # Public: try to parse a date string. If it fails use the default date
  def self.safe_date_parse(date_string, default_date = Date.current)
    begin
      Date.parse(date_string)
    rescue ArgumentError
      default_date
    end
  end
end
