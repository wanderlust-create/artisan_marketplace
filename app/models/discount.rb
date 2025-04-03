class Discount < ApplicationRecord
  belongs_to :product
  has_one :artisan, through: :product

  enum discount_type: { price: 1, percentage: 2 }

  # Validations
  validates :original_price, :discount_price, :discount_type, :start_date, :end_date, presence: true
  validates :percentage_off, presence: true, if: -> { percentage? }

  validates :discount_price, numericality: {
    greater_than: 0,
    less_than_or_equal_to: ->(discount) { discount.original_price || Float::INFINITY }
  }

  validate :end_date_after_start_date
  # validate :prevent_overlapping_discounts, on: :create

  # Scopes
  scope :by_artisan, ->(artisan_id) { joins(product: :artisan).where(products: { artisan_id: artisan_id }) }
  scope :current_and_upcoming_discounts, -> { where('end_date >= ?', Time.zone.today).order(:start_date) }

  private

  def end_date_after_start_date
    return unless start_date.present? && end_date.present? && start_date >= end_date

    errors.add(:end_date, 'must be after the start date')
  end

  def prevent_overlapping_discounts
    overlapping = product.discounts.where.not(id: id).where(
      'start_date < ? AND end_date > ?', end_date, start_date
    )
    errors.add(:base, 'Discount periods cannot overlap') if overlapping.exists?
  end
end
