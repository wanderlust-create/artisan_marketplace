FactoryBot.define do
  factory :admin do
    email { Faker::Internet.email }
    password { 'password' }
  end
end