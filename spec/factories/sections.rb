# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :section do
    sequence(:name) { |x| "Section #{x}" }
    anonymous_count 0
    descr "Lorem Ipusm"
    association :meeting, :factory => :meeting
  end
end
