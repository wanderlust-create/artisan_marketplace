require 'rails_helper'

RSpec.describe 'ArtisanViewsAllProducts', type: :feature do
  let(:artisan) { create(:artisan) }
  let!(:first_product) { FactoryBot.create(:product, artisan: artisan) }
  let!(:second_product) { FactoryBot.create(:product, artisan: artisan) }

  before do
    # Simulate artisan login
    login_as(artisan)
  end

  scenario 'Artisan visits the products index page' do
    visit artisan_products_path(artisan)
    expect(page).to have_content('Your Products')

    [first_product, second_product].each do |product|
      expect(page).to have_content(product.name)
      expect(page).to have_content(product.description)
      expect(page).to have_content(product.price)
      expect(page).to have_content(product.stock)
    end
  end

  scenario 'Artisan clicks on a product to view its details' do
    visit artisan_products_path(artisan)

    click_link "Show #{first_product.name}"
    expect(current_path).to eq(artisan_product_path(artisan, first_product))
    expect(page).to have_content(first_product.name)
    expect(page).to have_content(first_product.description)
    expect(page).to have_content(first_product.price)
    expect(page).to have_content(first_product.stock)
  end
end
