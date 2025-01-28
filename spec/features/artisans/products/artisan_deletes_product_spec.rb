require 'rails_helper'

RSpec.feature 'ArtisanDeletesProduct', type: :feature do
  let(:admin) { create(:admin) }
  let(:artisan) { create(:artisan, admin: admin) }
  let!(:product_one) { create(:product, artisan: artisan, name: 'Product One') }
  let!(:product_two) { create(:product, artisan: artisan, name: 'Product Two') }
  let(:another_artisan) { create(:artisan) }

  before do
    # Capybara.reset_sessions!
    login_as(artisan)
  end

  scenario 'Artisan deletes a product_one and verifies it is no longer listed', :js do
    visit dashboard_artisan_path(artisan)
    expect(page).to have_content(product_one.name)

    click_link 'Manage Products'
    expect(page).to have_current_path(artisan_products_path(artisan))

    # Navigate to the product_one show page
    click_link "Show #{product_one.name}"
    expect(page).to have_current_path artisan_product_path(artisan, product_one)

    # Confirm and delete the product_one
    accept_confirm "Are you sure you want to delete your #{product_one.name}?" do
      click_link "Delete #{product_one.name}"
    end
    # Verify redirection and success message
    expect(page).to have_current_path(dashboard_artisan_path(artisan))

    expect(page).to have_content('Product was successfully deleted.')

    # Verify product_one is no longer listed in the product_one index
    visit artisan_products_path(artisan)
    expect(page).not_to have_content(product_one.name)
  end

  scenario 'Deleted product is no longer accessible by its URL', :js do
    # Simulate deletion of the product in this scenario
    product_one.destroy

    # Attempt to access the deleted product via its URL
    visit artisan_product_path(artisan, product_one)
    expect(page).to have_content("The product you were looking for doesn't exist.")
    expect(page).to have_current_path(dashboard_artisan_path(artisan))
  end

  scenario 'Artisan cannot delete a product belonging to another artisan', :js do
    visit artisan_product_path(another_artisan, product_two)
    expect(page).to have_content('You are not authorized to access this page')
  end
end
