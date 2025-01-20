FactoryBot.define do
  factory :discount do
    association :product
    discount_price { Faker::Commerce.price(range: 1.0..500.0) }
    start_date { Date.today }
    end_date { Date.today + Faker::Number.between(from: 1, to: 30) }
  end
end
