# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :twitt do
    association :anonymous, :factory => :anonymous
    text "Lorem Ipsum"
  end
end
