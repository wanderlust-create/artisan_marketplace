require 'faker'

# Clear existing data
Admin.destroy_all
Artisan.destroy_all
Customer.destroy_all
Product.destroy_all
Review.destroy_all
Invoice.destroy_all
InvoiceItem.destroy_all
Transaction.destroy_all

# Create Admins
5.times do
  Admin.create!(
    email: Faker::Internet.unique.email,
    password: 'password' # Fixed password for simplicity
  )
end

# Create Artisans linked to Admins
10.times do
  Artisan.create!(
    store_name: Faker::Company.unique.name,
    email: Faker::Internet.unique.email,
    password: 'password',
    admin: Admin.order('RANDOM()').first # Random admin association
  )
end

# Create Customers
20.times do
  Customer.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email
  )
end

# Create Products linked to Artisans
Artisan.all.find_each do |artisan|
  rand(5..13).times do
    artisan.products.create!(
      name: Faker::Commerce.unique.product_name,
      description: Faker::Lorem.paragraph,
      price: Faker::Commerce.price(range: 10.0..500.0).round(2),
      stock: rand(5..100)
    )
  end
end

# Create Invoices linked to Customers
20.times do
  Invoice.create!(
    customer: Customer.all.sample,
    status: Invoice.statuses.keys.sample # Random status
  )
end

# Iterate through invoices and create transactions
Invoice.all.find_each do |invoice|
  rand(1..3).times do
    InvoiceItem.create!(
      invoice: invoice,
      product: Product.all.sample,
      quantity: rand(1..10),
      unit_price: Faker::Commerce.price(range: 10.0..500.0).round(2)
    )
  end

  # Create a single transaction for each invoice
  Transaction.create!(
    invoice: invoice,
    credit_card_number: Faker::Finance.credit_card(:visa).gsub(/[^0-9]/, ''), # Ensure only digits
    credit_card_expiration_date: Faker::Date.forward(days: rand(30..365)).strftime('%m/%y'), # Random future expiration date
    status: %i[successful failed].sample
  )
end

# Create Reviews linked to Products and Customers
Product.all.find_each do |product|
  rand(2..5).times do
    product.reviews.create!(
      rating: rand(1..5),
      text: Faker::Lorem.paragraph,
      customer: Customer.all.sample
    )
  end
end

Rails.logger.debug 'Seeding completed!'
Rails.logger.debug "#{Admin.count} admins created."
Rails.logger.debug "#{Artisan.count} artisans created."
Rails.logger.debug "#{Customer.count} customers created."
Rails.logger.debug "#{Product.count} products created."
Rails.logger.debug "#{Invoice.count} invoices created."
Rails.logger.debug "#{InvoiceItem.count} invoice items created."
Rails.logger.debug "#{Transaction.count} transactions created."
Rails.logger.debug "#{Review.count} reviews created."
