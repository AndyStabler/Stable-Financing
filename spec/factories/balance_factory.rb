FactoryGirl.define do

  factory :balance do | bal |

    trait :empty do
      bal.value 0.0
      bal.on DateTime.now
    end
  end

end
