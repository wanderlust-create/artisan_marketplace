# spec/factories/discount.rb
FactoryBot.define do
  factory :discount do
    association :product
    original_price { product.price }
    discount_type { 1 } # 1 = Price-based, 2 = Percentage-based
    discount_price { product.price - 10 } # $10 off by default
    percentage_off { nil } # only used if discount_type == 2
    start_date { Time.zone.today }
    end_date { Time.zone.today + 7 }
  end

  trait :percentage_discount do
    discount_type { 2 }
    percentage_off { 20 }
    discount_price { (product.price * 0.8).round(2) }
  end
end
