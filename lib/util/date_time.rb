module Util::DateTime
  class << self
    def months_between(from, to)
      (to.year - from.year) * 12 + to.month - from.month - (to.day >= from.day ? 0 : 1)
    end

    # Public: calculates the number of inclusive days between two dates
    #
    # Examples
    #
    #   days_between_inclusve(1, 5)
    #   # => 5
    def days_between_inclusive(from, to)
      (to - from).to_i + 1
    end

    # Public: calculates the number of inclusive days between two dates
    #
    # Examples
    #
    #   weeks_between_inclusve(1, 5)
    #   # => 5
    def weeks_between_inclusive(from, to)
      ((to - from) / 7).to_i + 1
    end
  end
end
