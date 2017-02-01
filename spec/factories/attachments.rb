FactoryGirl.define do
  factory :attachment do
    file File.new("#{Rails.root}/spec/spec_helper.rb")
    association :attachable
  end
end
