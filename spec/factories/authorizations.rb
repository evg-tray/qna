FactoryGirl.define do
  factory :authorization do
    user
    provider 'some_provier'
    uid '234234'
  end
end
