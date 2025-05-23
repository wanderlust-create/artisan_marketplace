require 'rails_helper'

RSpec.describe 'ArtisanCreatesDiscount', :js, type: :feature do
  let(:admin) { create(:admin) }
  let(:artisan) { create(:artisan, admin: admin) }
  let(:product) { create(:product, artisan: artisan, price: 50.00) }

  before do
    login_as(artisan)
  end

  scenario 'Artisan creates a discount with a specific discount price' do
    visit new_artisan_product_discount_path(artisan, product)
    expect(page).to have_content("Current Price: $#{product.price}")
    expect(page).to have_content("Create a Discount for #{product.name}")
    expect(page).to have_content('Discount Type')

    select 'Discount Price', from: 'Discount Type'
    fill_in 'Value', with: 40.0
    fill_in_discount_dates

    click_button 'Create Discount'
    expect(page).to have_current_path(artisan_product_path(artisan, product))
    expect(page).to have_content('Discount was successfully created.')

    within('table#discounts') do
      expect(page).to have_content('$40.00')
      expect(page).to have_content(Time.zone.today.strftime('%B %d, %Y'))
      expect(page).to have_content((Time.zone.today + 7).strftime('%B %d, %Y'))
    end
  end

  scenario 'Artisan creates a discount with a percentage reduction' do
    visit_discount_creation_page

    select 'Percentage Reduction', from: 'Discount Type'
    fill_in 'Value', with: 20
    fill_in_discount_dates

    click_button 'Create Discount'

    expect(page).to have_current_path(artisan_product_path(artisan, product))
    expect(page).to have_content('Discount was successfully created.')

    within('table#discounts') do
      expect(page).to have_content('$40.00') # 20% off $50.00
    end
  end

  scenario 'Validation fails when discount price exceeds regular product price' do
    visit_discount_creation_page

    select 'Discount Price', from: 'Discount Type'
    fill_in 'Value', with: product.price + 10 # too high
    fill_in_discount_dates

    click_button 'Create Discount'

    expect(page).to have_content("Discount price must be less than or equal to #{product.price}")
  end

  scenario 'Validation fails when required fields are missing' do
    visit_discount_creation_page

    click_button 'Create Discount'

    expect(page).to have_content('Failed to create discount. Please check the form for errors.')
    expect(page).to have_content("Discount price can't be blank")
    expect(page).to have_content('Discount price is not a number')
    expect(page).to have_content("Start date can't be blank")
    expect(page).to have_content("End date can't be blank")
  end

  scenario 'Validation fails when input exceeds 100% for percentage' do
    visit_discount_creation_page

    select 'Percentage Reduction', from: 'Discount Type'
    fill_in 'Value', with: 120
    fill_in_discount_dates

    click_button 'Create Discount'

    expect(page).to have_current_path(new_artisan_product_discount_path(artisan, product))
    expect(page).to have_content('Discount price must be greater than 0')
  end

  scenario 'Product page displays multiple discounts' do # rubocop:disable RSpec/ExampleLength
    product.discounts.create!(
      discount_price: 45.0,
      original_price: product.price,
      discount_type: 'price',
      start_date: Time.zone.today + 1,
      end_date: Time.zone.today + 8
    )

    product.discounts.create!(
      discount_price: 37.0,
      original_price: product.price,
      discount_type: 'price',
      start_date: Time.zone.today + 10,
      end_date: Time.zone.today + 17
    )

    visit artisan_product_path(artisan, product)

    within('table#discounts') do
      expect(page).to have_content('$45.00')
      expect(page).to have_content('$37.00')
    end
  end

  private

  def visit_discount_creation_page
    visit new_artisan_product_discount_path(artisan, product)
    expect(page).to have_content("Current Price: $#{product.price}")
  end

  def fill_in_discount_dates
    fill_in 'Start Date', with: Time.zone.today
    fill_in 'End Date', with: Time.zone.today + 7
  end
end
