# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :meeting do
    descr "Lorem Ipsum"
    sequence(:name) { |x| "Meeting #{x}" }
    association :user, :factory => :user
  end
end
