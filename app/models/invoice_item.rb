class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :product
end
