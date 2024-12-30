require 'rails_helper'

RSpec.describe 'ArtisanCreatesProduct', type: :feature do
  let(:admin) { create(:admin) }
  let(:artisan) { create(:artisan, admin: admin) }

  before do
    login_as(artisan) # Simulate artisan login
  end

  scenario 'Artisan navigates to the product creation page from the dashboard' do # rubocop:disable RSpec/MultipleExpectations
    visit dashboard_artisan_path(artisan)
    expect(page).to have_content('Artisan Dashboard')

    click_link 'Manage Products'
    expect(page).to have_current_path(artisan_products_path(artisan))
    expect(page).to have_content('Your Products')

    click_link 'Add New Product'
    expect(page).to have_current_path(new_artisan_product_path(artisan))
    expect(page).to have_content('Create a New Product')
    expect(page).to have_field('Product Name')
    expect(page).to have_field('Product Description')
    expect(page).to have_field('Price')
    expect(page).to have_field('Quantity in Stock')
  end

  scenario 'Artisan fills in and submits the new product form' do
    create_product('Handmade Mug', 'A beautiful handmade ceramic mug.', 15.99, 10)
    expect(page).to have_current_path(dashboard_artisan_path(artisan))
    expect(page).to have_content('Product was successfully created.')
    expect(page).to have_content('Handmade Mug')
  end

  scenario 'The created product appears in the product index' do
    create_product('Handmade Mug', 'A beautiful handmade ceramic mug.', 15.99, 10)

    visit artisan_products_path(artisan)
    expect(page).to have_current_path(artisan_products_path(artisan))
    expect(page).to have_content('Handmade Mug')
    expect(page).to have_content('A beautiful handmade ceramic mug.')
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
