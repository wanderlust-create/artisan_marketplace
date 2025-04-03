class DiscountSerializer < ActiveModel::Serializer
  attributes :id, :original_price, :discount_price, :percentage_off,
             :start_date, :end_date, :discount_type
end

