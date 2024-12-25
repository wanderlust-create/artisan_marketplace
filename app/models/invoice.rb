class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items, dependent: :destroy
  has_many :products, through: :invoice_items
  has_many :transactions, dependent: :destroy

  enum status: { pending: 0, shipped: 1, completed: 2, canceled: 3 }

  validates :status, presence: true
end
