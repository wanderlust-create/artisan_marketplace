require 'rails_helper'

RSpec.describe 'ArtisanEditsProduct', type: :feature do
  let(:artisan) { create(:artisan) }
  let(:product) { create(:product, artisan: artisan) }

  before do
    # Simulate artisan login
    login_as(artisan)
  end

  scenario 'Artisan visits the product show page' do
    visit edit_artisan_product_path(artisan, product)
    expect(page).to have_content('Edit Product')
    expect(page).to have_field('Product Name', with: product.name)
    expect(page).to have_field('Product Description', with: product.description)
    expect(page).to have_field('Price', with: product.price)
    expect(page).to have_field('Quantity in Stock', with: product.stock)
  end

  scenario 'Artisan updates and submits the edit product form' do
    update_product('Updated Mug', 'An updated description of the mug.', 19.99, 5)
    expect(page).to have_content('Product was successfully updated.')
    expect(page).to have_content('Updated Mug')
    expect(page).to have_content('19.99')
    expect(page).to have_content('5')
  end

  private

  def update_product(name, description, price, stock)
    visit edit_artisan_product_path(artisan, product)
    fill_in 'Product Name', with: name
    fill_in 'Product Description', with: description
    fill_in 'Price', with: price
    fill_in 'Quantity in Stock', with: stock
    click_button 'Update Product'
  end
end
