class Discount < ApplicationRecord
  belongs_to :product
  has_one :artisan, through: :product

  validates :discount_price, presence: true, numericality: { greater_than: 0 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  # Scope to retrieve all discounts associated with a specific artisan.
  # Joins the products and artisans tables to filter discounts by artisan ID.
  scope :by_artisan, ->(artisan_id) { joins(product: :artisan).where(products: { artisan_id: artisan_id }) }

  private
  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if start_date >= end_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
