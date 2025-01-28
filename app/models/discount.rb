class Discount < ApplicationRecord
  belongs_to :product
  has_one :artisan, through: :product

  # Validations
  validates :discount_price, presence: true, numericality: {
    greater_than: 0,
    less_than_or_equal_to: ->(discount) { discount.product&.price || Float::INFINITY }
  }
  validates :start_date, :end_date, presence: true
  validate :end_date_after_start_date
  # validate :prevent_overlapping_discounts, on: :create

  # Scopes
  scope :by_artisan, ->(artisan_id) { joins(product: :artisan).where(products: { artisan_id: artisan_id }) }
  scope :current_and_upcoming_discounts, -> { where('end_date >= ?', Time.zone.today).order(:start_date) }

  private

  # Validates that the end date is after the start date.
  def end_date_after_start_date
    return unless start_date.present? && end_date.present? && start_date >= end_date

    errors.add(:end_date, 'must be after the start date')
  end

  # Validates that discounts for the same product do not overlap.
  def prevent_overlapping_discounts
    overlapping = product.discounts.where.not(id: id).where(
      'start_date < ? AND end_date > ?', end_date, start_date
    )
    errors.add(:base, 'Discount periods cannot overlap') if overlapping.exists?
  end
end
