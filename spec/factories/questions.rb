FactoryGirl.define do
  factory :question do
    title Faker::Lorem.characters(30)
    body Faker::Lorem.characters(50)

    trait :invalid do
      title nil
      body nil
    end
  end
end
