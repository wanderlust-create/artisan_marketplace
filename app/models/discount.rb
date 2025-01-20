class Discount < ApplicationRecord
  belongs_to :product
  has_one :artisan, through: :product

  # Ensure discount price is less than or equal to the product price and greater than 0.
  # Allows nil values when the user enters a percentage discount, which will be calculated in the controller.
  validates :discount_price, presence: true, numericality: {
    greater_than: 0,
    less_than_or_equal_to: ->(discount) { discount.product&.price || Float::INFINITY }
  }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  # Scope to retrieve all discounts associated with a specific artisan.
  # Joins the products and artisans tables to filter discounts by artisan ID.
  scope :by_artisan, ->(artisan_id) { joins(product: :artisan).where(products: { artisan_id: artisan_id }) }

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    return unless start_date >= end_date

    errors.add(:end_date, 'must be after the start date')
  end
end
