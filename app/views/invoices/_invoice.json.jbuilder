json.extract! invoice, :id, :customer_id, :status, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
