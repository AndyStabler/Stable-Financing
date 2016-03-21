class Util::DateTimeUtil
  class << self
    def months_between(from, to)
      (to.year - from.year) * 12 + to.month - from.month - (to.day >= from.day ? 0 : 1)
    end
  end
end
