module Util::DateTime
  class << self

    def months_between_inclusive(from, to)
      years_diff(from, to) +
      blunt_months_diff(from, to) -
      (incomplete_month?(from, to) ? 1 : 0) +
      1
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

    private

    def years_diff(from, to)
      (to.year - from.year) * 12
    end

    # Public: simple subtraction of months
    # Examples
    #   blunt_month_diff(25 Aug, 1 Sep)
    #   # =>  1
    def blunt_months_diff(from, to)
      to.month - from.month
    end

    # Public: whether the days between two months is not a fully month
    # Examples
    #   incomplete_month?(25 Aug, 1 Sep)
    #   # => true
    #   incomplete_month?(25 Aug, 25 Sep)
    #   # => false
    #   incomplete_month?(30 Jan, 28 Feb) (when Feb has 28 days)
    #   # => false
    #   incomplete_month?(30 Jan, 28 Feb) (when Feb has 29 days)
    #   # => true
    def incomplete_month?(from, to)
      to.day < from.day && to != to.end_of_month
    end
  end
end
