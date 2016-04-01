FactoryGirl.define do

  factory :balance do

    trait :empty do
      value 0.0
    end

    trait :today do
      on DateTime.current
    end

    trait :yesterday do
      on DateTime.current-1.day
    end

  end

end
