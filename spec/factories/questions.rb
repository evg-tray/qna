FactoryGirl.define do
  factory :question do
    title { Faker::Lorem.characters(30) }
    body { Faker::Lorem.characters(50) }
    user

    trait :invalid do
      title nil
      body nil
    end

    trait :with_answers do
      answers { [create(:answer), create(:answer)] }
    end
  end
end
