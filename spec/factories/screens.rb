# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :screen do
    association :section, :factory => :section
    state { ["banner", "twitts", "question"].sample }
  end
end
