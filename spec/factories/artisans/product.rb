FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    price { Faker::Commerce.price(range: 10.0..500.0).round(2) }
    stock { Faker::Number.between(from: 1, to: 50) }
    artisan # Associates the product with an artisan
  end
end
