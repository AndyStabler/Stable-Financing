FactoryGirl.define do

  factory :user do | user |

    user.name "Homer Simpson"
    user.email "homer@aol.com"
    user.password "password"
    user.password_confirmation "password"

    trait :with_empty_balance do
      after(:create) do |user|
        create(:balance, :empty, user: user)
      end
    end
  end

end
