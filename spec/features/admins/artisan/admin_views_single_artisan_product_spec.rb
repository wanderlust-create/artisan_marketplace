require 'rails_helper'

RSpec.describe 'Admin views artisan product show page', type: :feature do
  let!(:admin1) { create(:admin) }
  let!(:admin2) { create(:admin) }
  let!(:artisan) { create(:artisan, admin: admin1) }
  let!(:product) { create(:product, artisan: artisan, name: 'Handmade Vase', description: 'A beautiful vase.', price: 50.0, stock: 100) }

  before { login_as(admin1) }

  describe 'Admin views a product' do
    it 'displays the product details but does not show the stock' do
      # Visit the product's show page
      visit artisan_product_path(artisan, product)

      # Verify product details
      expect(page).to have_content('Handmade Vase')
      expect(page).to have_content('A beautiful vase.')
      expect(page).to have_content('$50.00')

      # Verify stock is not displayed
      expect(page).not_to have_content('Stock:')
      expect(page).not_to have_content('100')

      # Verify no edit or delete links are present
      expect(page).not_to have_link('Edit')
      expect(page).not_to have_link('Delete')
    end

    it 'has navigation links back to artisan products index and admin artisans index' do
      visit artisan_product_path(artisan, product)

      # Verify navigation links
      expect(page).to have_link('Back to Artisan Products', href: artisan_products_path(artisan))
      expect(page).to have_link('Back to All Artisans', href: admin_artisans_path(admin1))
    end
  end

  describe 'Another admin views the product' do
    before { login_as(admin2) }

    it 'displays the product details but does not show the stock' do
      visit artisan_product_path(artisan, product)

      # Verify product details
      expect(page).to have_content('Handmade Vase')
      expect(page).to have_content('A beautiful vase.')
      expect(page).to have_content('$50.00')

      # Verify stock is not displayed
      expect(page).not_to have_content('Stock:')
      expect(page).not_to have_content('100')

      # Verify no edit or delete links are present
      expect(page).not_to have_link('Edit')
      expect(page).not_to have_link('Delete')
    end
  end
end
