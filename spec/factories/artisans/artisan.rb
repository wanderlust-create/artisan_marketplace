FactoryBot.define do
  factory :artisan do
    store_name { Faker::Company.name }
    email { Faker::Internet.email }
    password { 'password' }
    admin
  end
end
