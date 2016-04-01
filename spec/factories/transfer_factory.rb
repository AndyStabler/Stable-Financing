FactoryGirl.define do

  factory :transfer do

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

  factory :transfer_daily, class: TransferDaily, parent: :transfer do
  end

  factory :transfer_weekly, class: TransferWeekly, parent: :transfer do
  end

  factory :transfer_monthly, class: TransferMonthly, parent: :transfer do
  end

  factory :transfer_no_recurrence, class: TransferNoRecurrence, parent: :transfer do
  end

end
