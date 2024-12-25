class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :product

  enum status: { pending: 0, shipped: 1, completed: 2, canceled: 3 }

  validates :status, presence: true
end
