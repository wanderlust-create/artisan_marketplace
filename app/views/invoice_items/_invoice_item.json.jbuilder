json.extract! invoice_item, :id, :invoice_id, :product_id, :quantity, :unit_price, :created_at, :updated_at
json.url invoice_item_url(invoice_item, format: :json)
