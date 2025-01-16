require 'rails_helper'

RSpec.feature 'ArtisanDeletesProduct', type: :feature do
  let(:admin) { create(:admin) }
  let(:artisan) { create(:artisan, admin: admin) }
  let!(:product) { create(:product, artisan: artisan, name: 'Handmade Vase', description: 'A beautiful vase.', price: 50.0, stock: 10) }

  before do
    login_as(artisan)
  end

  # Rubocop is disabled for this block because the scenario needs to test multiple steps and the Product needs to stay deleted
  scenario 'Artisan deletes a product and verifies it is no longer listed', :js do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
    # Step 1: Navigate to the artisan dashboard
    visit dashboard_artisan_path(artisan)
    expect(page).to have_content('Artisan Dashboard')
    expect(page).to have_content(product.name)

    # Step 2: Navigate to the product list page
    click_link 'Manage Products'
    expect(page).to have_current_path(artisan_products_path(artisan))
    expect(page).to have_content(product.name)
    expect(page).to have_content(product.description)
    expect(page).to have_content(product.price)
    expect(page).to have_content(product.stock)

    click_link "Show #{product.name}"
    expect(page).to have_current_path(artisan_product_path(artisan, product))

    # Step 3: Handle Turbo's confirmation modal to delete the product
    accept_confirm "Are you sure you want to delete your #{product.name}?" do
      click_link "Delete #{product.name}"
    end

    # Step 4: Verify redirection and success message
    expect(page).to have_current_path(dashboard_artisan_path(artisan))
    expect(page).to have_content('Product was successfully deleted.')

    # Step 5: Verify product is no longer listed in the product index
    visit artisan_products_path(artisan)
    expect(page).to have_current_path(artisan_products_path(artisan))
    expect(page).not_to have_content(product.name)
  end
end
