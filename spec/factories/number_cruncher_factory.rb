FactoryGirl.define do

  factory :number_cruncher do
    initialize_with { new(user) }
  end
end
