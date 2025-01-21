FactoryBot.define do
  factory :discount do
    association :product

    # Generate discount price as 10%-35% off the product price
    discount_price do
      percentage = Faker::Number.between(from: 10, to: 35) / 100.0 # Generate a random percentage between 10% and 35%
      product.price * (1 - percentage) # Apply the percentage to get the discounted price
    end

    # Dynamic non-overlapping start and end dates
    sequence(:start_date) { |n| Time.zone.today + (n * 10).days }
    sequence(:end_date) { |n| Time.zone.today + (n * 10).days + 7 }

    # Valid discount trait (optional for overrides)
    trait :valid_discount do
      after(:build) do |discount|
        discount.discount_price = discount.product.price * 0.8 # Fixed 20% discount for valid cases
      end
    end
  end
end
