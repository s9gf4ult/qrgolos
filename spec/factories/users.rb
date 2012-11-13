# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    passwd = SecureRandom.hex(10)
    password passwd
    password_confirmation passwd
    remember_me false
  end
end
