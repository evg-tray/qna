FactoryGirl.define do
  factory :omnitoken do
    user
    authorization
    email { Faker::Internet.email }
    token { Faker::Internet.device_token }
  end
end
