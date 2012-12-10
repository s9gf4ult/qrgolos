# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :anonymous, :class => 'Anonymous' do
    association :section, :factory => :section
    sequence(:name) { |x| "Anonymous #{x}" }
    sequence(:name_number) { |x| x }
  end
end
