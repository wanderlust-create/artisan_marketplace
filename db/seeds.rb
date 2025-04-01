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

Rails.logger.debug '🌱 Seeding dev/test data...'

# Admins
super_admin = Admin.create!(
  email: 'superadmin@example.com',
  password: 'password',
  password_confirmation: 'password',
  role: :super_admin
)

regular_admin = Admin.create!(
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password',
  role: :regular
)

unauthorized_admin = Admin.create!(
  email: 'unauthorized_admin@example.com',
  password: 'password',
  password_confirmation: 'password',
  role: :regular
)

# Artisans, Products, and Discounts
[super_admin, regular_admin].each do |admin|
  2.times do
    artisan = Artisan.create!(
      email: Faker::Internet.unique.email,
      password: 'password',
      password_confirmation: 'password',
      store_name: Faker::Company.name,
      admin: admin
    )

    2.times do
      product = artisan.products.create!(
        name: Faker::Commerce.product_name,
        description: Faker::Lorem.sentence,
        price: Faker::Commerce.price(range: 10..100),
        stock: rand(10..50)
      )

      product.discounts.create!(
        discount_price: (product.price * 0.8).round(2),
        start_date: Time.zone.today,
        end_date: Time.zone.today + 30
      )
    end
  end
end

# Customers, Invoices, Reviews, Transactions
3.times do
  customer = Customer.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email
  )

  invoice = customer.invoices.create!(status: :pending)

  Product.order('RANDOM()').limit(2).each do |product|
    invoice.invoice_items.create!(
      product: product,
      quantity: rand(1..3),
      unit_price: product.price,
      status: :pending
    )

    product.reviews.create!(
      customer: customer,
      rating: rand(3..5),
      text: Faker::Lorem.sentence
    )
  end

  invoice.transactions.create!(
    credit_card_number: Faker::Number.number(digits: 16),
    credit_card_expiration_date: '12/26',
    status: :successful
  )
end

Rails.logger.debug '✅ Done seeding!'

Rails.logger.debug 'Seeding completed!'
Rails.logger.debug "#{Admin.count} admins created."
Rails.logger.debug "#{Artisan.count} artisans created."
Rails.logger.debug "#{Customer.count} customers created."
Rails.logger.debug "#{Product.count} products created."
Rails.logger.debug "#{Invoice.count} invoices created."
Rails.logger.debug "#{InvoiceItem.count} invoice items created."
Rails.logger.debug "#{Transaction.count} transactions created."
Rails.logger.debug "#{Review.count} reviews created."

# rubocop:disable Rails/Output
puts 'Seeding completed!'
puts "#{Admin.count} admins created."
puts "#{Artisan.count} artisans created."
puts "#{Customer.count} customers created."
puts "#{Product.count} products created."
puts "#{Invoice.count} invoices created."
puts "#{InvoiceItem.count} invoice items created."
puts "#{Transaction.count} transactions created."
puts "#{Review.count} reviews created."
puts "#{Discount.count} discounts created."
# rubocop:enable Rails/Output
