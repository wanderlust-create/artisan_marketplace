require 'rails_helper'

RSpec.describe 'Admin views artisan products', type: :feature do
  let!(:admin1) { create(:admin) }
  let!(:admin2) { create(:admin) }

  let!(:artisan1) { create_list(:artisan, 3, admin: admin1) }
  let!(:artisan2) { create_list(:artisan, 3, admin: admin2) }

  before do
    artisan1.each do |artisan|
      create_list(:product, 2, artisan: artisan, stock: 100)
    end

    artisan2.each do |artisan|
      create_list(:product, 2, artisan: artisan, stock: 100)
    end

    login_as(admin1)
  end

  describe "Admin views their own artisans' products" do
    it 'displays all products belonging to an artisan' do
      artisan = artisan1.first
      visit artisan_products_path(artisan.id)

      artisan.reload.products.each do |product|
        expect(page).to have_content(product.name)
        expect(page).to have_content(product.description)
        expect(page).to have_content(product.price)
        expect(page).not_to have_content(product.stock)
      end
    end

    it 'does not allow admin to edit or delete products' do
      artisan = artisan1.first
      visit artisan_products_path(artisan.id)

      artisan.reload.products.each do |_product|
        expect(page).not_to have_link('Edit')
        expect(page).not_to have_link('Delete')
      end
    end

    it "navigates to a product's show page" do
      artisan = artisan1.first
      product = artisan.reload.products.first
      visit artisan_products_path(artisan.id)

      click_link product.name
      expect(current_path).to eq(artisan_product_path(artisan, product))
    end
  end

  describe "Admin views other admins' artisans' products" do
    it 'displays products belonging to artisans managed by another admin' do
      artisan = artisan2.first
      visit artisan_products_path(artisan.id)

      artisan.reload.products.each do |product|
        expect(page).to have_content(product.name)
        expect(page).to have_content(product.description)
        expect(page).to have_content(product.price)
        expect(page).not_to have_content(product.stock)
      end
    end

    it "does not allow admin to edit or delete products of other admins' artisans" do
      artisan = artisan2.first
      visit artisan_products_path(artisan.id)

      artisan.reload.products.each do |_product|
        expect(page).not_to have_link('Edit')
        expect(page).not_to have_link('Delete')
      end
    end
  end

  describe 'Navigation links' do
    it "has a link to navigate back to admin's artisan index page" do
      artisan = artisan1.first
      visit artisan_products_path(artisan.id)

      click_link 'Back to All Artisans'
      expect(current_path).to eq(admin_artisans_path(admin1))
    end
  end

  scenario 'Admin sees a message if no artisans are found', :js do
    # Create a new admin with no artisans
    empty_admin = FactoryBot.create(:admin, email: 'empty_admin@example.com', password: 'password')
    login_as(empty_admin)
    visit admin_artisans_path(empty_admin)

    # Verify message is displayed
    expect(page).to have_content('No artisans found. Create your first artisan!')
  end

  scenario "Admin does not see artisan-specific links on the artisan's products page" do
    # Log in as an admin
    login_as(admin1)

    # Visit the artisan's products page
    visit artisan_products_path(artisan1.first)

    # Verify that the admin does not see artisan-specific links
    expect(page).not_to have_link('Add New Product', href: new_artisan_product_path(artisan1.first))
    expect(page).not_to have_link('Back to Dashboard', href: dashboard_artisan_path(artisan1.first))
  end
end
