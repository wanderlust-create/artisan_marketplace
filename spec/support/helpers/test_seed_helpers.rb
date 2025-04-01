module TestSeedHelpers
  def super_admin
    Admin.find_by(email: 'superadmin@example.com')
  end

  def regular_admin
    Admin.find_by(email: 'admin@example.com')
  end

  def unauthorized_admin
    Admin.find_by(email: 'unauthorized_admin@example.com')
  end

  def first_artisan
    Artisan.first
  end

  def random_product
    Product.order('RANDOM()').first
  end

  def customer_one
    Customer.first
  end

  def seeded_invoice
    Invoice.first
  end

  def seeded_transaction
    Transaction.first
  end
end
