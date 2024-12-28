require 'rails_helper'

RSpec.describe 'ArtisanCreatesProduct', type: :feature do
  let(:admin) { create(:admin) }
  let(:artisan) { create(:artisan, admin: admin) }

  before do
    # Simulate artisan login
    login_as(artisan)
  end

  scenario 'Artisan visits the new product page' do
    visit new_artisan_product_path(artisan)
    expect(page).to have_content('Create a New Product')
    expect(page).to have_field('Product Name')
    expect(page).to have_field('Product Description')
    expect(page).to have_field('Price')
    expect(page).to have_field('Quantity in Stock')
  end

  scenario 'Artisan fills in and submits the new product form' do
    create_product('Handmade Mug', 'A beautiful handmade ceramic mug.', 15.99, 10)
    expect(page).to have_content('Product was successfully created.')
    expect(page).to have_content('Handmade Mug')
    expect(page).to have_content('15.99')
    expect(page).to have_content('10')
  end

  private

  def create_product(name, description, price, stock)
    visit new_artisan_product_path(artisan)
    fill_in 'Product Name', with: name
    fill_in 'Product Description', with: description
    fill_in 'Price', with: price
    fill_in 'Quantity in Stock', with: stock
    click_button 'Create Product'
  end
end
