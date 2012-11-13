# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    association :section, :factory => :section
    kind { ["check", "radio"].sample }
    question "What ?"
  end
end
