FactoryGirl.define do
  factory :answer do
    body "MyText #{'A' * 20}"
    question

    trait :invalid_body do
      body nil
    end

    trait :question_nil do
      question nil
    end
  end
end
