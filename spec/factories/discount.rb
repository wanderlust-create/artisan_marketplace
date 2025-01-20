FactoryBot.define do
  factory :discount do
    association :product
    discount_price { Faker::Commerce.price(range: 0.01..100.0) } # Default range
    start_date { Time.zone.today }
    end_date { Time.zone.today + 7 }
    # Ensures the discount price is less than the product price
    trait :valid_discount do
      after(:build) do |discount|
        discount.discount_price = discount.product.price * 0.8 # 20% discount
      end
    end
  end
end
