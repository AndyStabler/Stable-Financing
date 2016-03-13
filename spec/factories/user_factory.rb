FactoryGirl.define do

  factory :user do | user |

    trait :homer do
      user.name "Homer Simpson"
      user.email "homer@aol.com"
      user.password "password"
      user.password_confirmation "password"
    end
  end

end
