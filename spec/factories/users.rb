FactoryGirl.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password }
    admin false
  end
end
