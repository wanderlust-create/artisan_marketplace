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
    email: Faker::Internet.email,
    password: 'password' # Fixed password for simplicity
  )
end

# Create Artisans linked to Admins
10.times do
  Artisan.create!(
    store_name: Faker::Company.name,
    email: Faker::Internet.email,
    password: 'password',
    admin: Admin.order('RANDOM()').first # Random admin association
  )
end

# Create Customers
20.times do
  Customer.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email
  )
end

# Create Products linked to Artisans
Artisan.all.find_each do |artisan|
  5.times do
    artisan.products.create!(
      name: Faker::Commerce.product_name,
      description: Faker::Lorem.sentence,
      price: Faker::Commerce.price(range: 10.0..500.0).round(2),
      stock: Faker::Number.between(from: 1, to: 50)
    )
  end
end

# Create Invoices linked to Customers
10.times do
  Invoice.create!(
    customer: Customer.all.sample,
    status: Invoice.statuses.keys.sample # Ensures valid enum keys for status
  )
end

# Create Invoice Items linked to Invoices and Products
Invoice.all.find_each do |invoice|
  2.times do
    InvoiceItem.create!(
      invoice: invoice,
      product: Product.all.sample,
      quantity: Faker::Number.between(from: 1, to: 5),
      unit_price: Faker::Commerce.price(range: 10.0..500.0).round(2)
    )
  end

  # Create Transactions linked to Invoices
  Transaction.create!(
    invoice: invoice,
    credit_card_number: Faker::Finance.credit_card(:visa).gsub(/[^0-9]/, ''), # Ensure only digits
    credit_card_expiration_date: Faker::Date.forward(days: 365).strftime('%m/%y'), # Valid future expiration date
    status: %i[successful failed].sample
  )
end

# Create Reviews linked to Products and Customers
Product.all.find_each do |product|
  3.times do
    product.reviews.create!(
      rating: Faker::Number.between(from: 1, to: 5),
      text: Faker::Lorem.paragraph,
      customer: Customer.all.sample
    )
  end
end

# rubocop:disable Rails/Output
puts "Seeding completed!"
puts "#{Admin.count} admins created."
puts "#{Artisan.count} artisans created."
puts "#{Customer.count} customers created."
puts "#{Product.count} products created."
puts "#{Invoice.count} invoices created."
puts "#{InvoiceItem.count} invoice items created."
puts "#{Transaction.count} transactions created."
puts "#{Review.count} reviews created."
# rubocop:enable Rails/Output
