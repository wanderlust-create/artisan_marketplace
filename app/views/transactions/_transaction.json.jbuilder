json.extract! transaction, :id, :invoice_id, :credit_card_number, :credit_card_expiration_date, :status, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
