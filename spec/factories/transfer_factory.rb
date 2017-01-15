FactoryGirl.define do

  factory :transfer do

    amount 20.00
    on DateTime.current
    outgoing true
    reference "Cake mix"

    trait :incoming do
      outgoing false
    end

    trait :outgoing do
      outgoing true
    end

    trait :today do
      on DateTime.current
    end

    trait :yesterday do
      on DateTime.current-1.day
    end
  end

  factory :transfer_daily, class: Transfer::Daily, parent: :transfer do
  end

  factory :transfer_weekly, class: Transfer::Weekly, parent: :transfer do
  end

  factory :transfer_monthly, class: Transfer::Monthly, parent: :transfer do
  end

  factory :transfer_no_recurrence, class: Transfer::NoRecurrence, parent: :transfer do
  end

end
