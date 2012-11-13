# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vote do
    anonymous do
      s = answer_variant.question.section
      FactoryGirl.create :anonymous, :section => s
    end
    association :answer_variant, :factory => :answer_variant
    vote 1
  end
end
