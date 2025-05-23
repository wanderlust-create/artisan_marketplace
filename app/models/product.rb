class Product < ApplicationRecord
  belongs_to :artisan
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :reviews, dependent: :destroy
  has_many :discounts, dependent: :destroy

  validates :name, :price, :stock, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :with_active_discounts, lambda {
    joins(:discounts)
      .merge(Discount.active_today)
      .distinct
  }
end
