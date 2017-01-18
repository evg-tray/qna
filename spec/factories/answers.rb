FactoryGirl.define do
  factory :answer do
    body { Faker::Lorem.characters(50) }
    question
    user

    trait :invalid_body do
      body nil
    end

    trait :question_nil do
      question nil
    end
  end
end
