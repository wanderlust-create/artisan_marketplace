json.extract! review, :id, :rating, :text, :product_id, :customer_id, :created_at, :updated_at
json.url review_url(review, format: :json)
