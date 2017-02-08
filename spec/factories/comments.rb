FactoryGirl.define do
  factory :comment do
    body { Faker::Lorem.characters(15) }
    association :commentable
    user
  end
end
