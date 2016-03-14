FactoryGirl.define do

  factory :transfer do

    trait :incoming do
      outgoing false
    end

    trait :outgoing do
      outgoing true
    end

    trait :no_recurrence do
      recurrence Transfer.recurrences[:no]
    end

    trait :daily do
      recurrence Transfer.recurrences[:daily]
    end

    trait :weekly do
      recurrence Transfer.recurrences[:weekly]
    end

    trait :monthly do
      recurrence Transfer.recurrences[:monthly]
    end
  end
end
