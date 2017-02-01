FactoryGirl.define do
  factory :vote do
    rating 1
    association :votable
    user
  end
end
