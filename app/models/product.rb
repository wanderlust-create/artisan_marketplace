class Product < ApplicationRecord
  belongs_to :artisan
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :reviews, dependent: :destroy

  validates :name, :price, :stock, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
