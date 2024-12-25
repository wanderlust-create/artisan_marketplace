json.extract! artisan, :id, :store_name, :email, :password_digest, :admin_id, :created_at, :updated_at
json.url artisan_url(artisan, format: :json)
