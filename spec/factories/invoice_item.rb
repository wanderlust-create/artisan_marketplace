FactoryBot.define do
  factory :invoice_item do
    invoice
    product
    quantity { Faker::Number.between(from: 1, to: 5) }
    unit_price { Faker::Commerce.price(range: 10.0..500.0).round(2) }
    status { :pending } # Use a valid enum value
  end
end
