namespace :db do
  namespace :seed do
    desc 'Seed test/demo data (admins, artisans, products, customers, etc)'
    task test_data: :environment do
      puts '🌱 Re-seeding test/demo data...'

      # Optional: Reset the DB first
      Rake::Task['db:reset'].invoke

      # Then seed it
      load Rails.root.join('db/seeds.rb')

      puts '✅ Seeding complete!'
    end
  end
end

namespace :db do
  namespace :seed do
    desc 'Clean up test/demo data and reseed without resetting the DB'
    task clean_reseed: :environment do
      puts '🧹 Cleaning test/demo data...'

      # Destroy all seeded records in the right order
      Transaction.delete_all
      InvoiceItem.delete_all
      Invoice.delete_all
      Review.delete_all
      Discount.delete_all
      Product.delete_all
      Artisan.delete_all
      Customer.delete_all
      Admin.delete_all

      puts '🔁 Re-seeding...'
      load Rails.root.join('db/seeds.rb')

      puts '✅ Done! Fresh test/demo data loaded.'
    end
  end
end
