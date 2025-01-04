FactoryBot.define do
  factory :admin do
    email { Faker::Internet.email }
    password { 'password' }
    role { :regular }

    trait :super_admin do
      role { :super_admin }
    end
  end
end
