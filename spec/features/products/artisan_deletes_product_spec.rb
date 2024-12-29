require 'rails_helper'

RSpec.feature 'ArtisanDeletesProduct', type: :feature do
  let(:admin) { create(:admin) }
  let(:artisan) { create(:artisan, admin: admin) }

  before do
    FactoryBot.create(:product, artisan: artisan, name: 'Handmade Vase', price: 50.00, stock: 10)
    login_as(artisan)
  end

  scenario 'Artisan visits the products list page' do
    visit artisan_path(artisan)
    expect(page).to have_content('Handmade Vase')
    expect(page).to have_content('$50.00')
    expect(page).to have_content('10')
  end

  scenario 'Artisan deletes a product with Turbo confirmation', :js do
    visit artisan_path(artisan)

    expect(page).to have_content('Handmade Vase')

    # Handle Turbo's confirmation modal
    accept_confirm 'Are you sure you want to delete your Handmade Vase?' do
      click_link 'Delete Handmade Vase'
    end

    expect(page).to have_content('Product was successfully deleted.')
    expect(page).not_to have_content('Handmade Vase')
  end
end
