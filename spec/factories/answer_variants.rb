# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer_variant do
    sequence(:text) {|x| "Variant #{x}" }
    association :question, :factory => :question
    position do
      question                  # initiate question generation at first
      self.last_position
    end
  end
end
