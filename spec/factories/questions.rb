FactoryGirl.define do
  factory :question do
    title "MyString #{'A' * 10}"
    body "MyText #{'A' * 20}"

    trait :invalid do
      title nil
      body nil
    end
  end
end
