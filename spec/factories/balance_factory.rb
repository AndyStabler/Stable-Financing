FactoryGirl.define do

  factory :balance do

    trait :empty do
      value 0.0
    end

    trait :today do
      on DateTime.now
    end

    trait :yesterday do
      on DateTime.now-1.day
    end

  end

end
