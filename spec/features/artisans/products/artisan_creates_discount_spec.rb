require 'rails_helper'

RSpec.describe 'ArtisanCreatesDiscount', type: :feature do
  let(:artisan) { create(:artisan) }
  let(:product) { create(:product, artisan: artisan, price: 50.0) }

  before do
    login_as(artisan)
  end

  scenario 'Artisan creates a discount with a specific discount price', :js do
    visit_discount_creation_page

    select 'Discount Price', from: 'Discount Type'
    fill_in 'Value', with: 40.0
    fill_in_discount_dates

    click_button 'Create Discount'
    expect(page).to have_current_path(artisan_product_path(artisan, product))
    expect(page).to have_content('Discount was successfully created.')

    # Expectations for the discounts table
    within('table#discounts') do
      expect(page).to have_css('tr#discount-1')
      expect(page).to have_content('$40.00')
      expect(page).to have_content(Time.zone.today.strftime('%B %d, %Y'))
      expect(page).to have_content((Time.zone.today + 7).strftime('%B %d, %Y'))
    end
  end

  scenario 'Artisan creates a discount with a percentage reduction', :js do
    visit_discount_creation_page

    select 'Percentage Reduction', from: 'Discount Type'
    fill_in 'Value', with: 20
    fill_in_discount_dates

    click_button 'Create Discount'

    expect(page).to have_current_path(artisan_product_path(artisan, product))
    expect(page).to have_content('Discount was successfully created.')

    # Expectations for the discounts table
    within('table#discounts') do
      expect(page).to have_css('tr#discount-1')
      expect(page).to have_content('$40.00') # 20% off $50.00
      expect(page).to have_content(Time.zone.today.strftime('%B %d, %Y'))
      expect(page).to have_content((Time.zone.today + 7).strftime('%B %d, %Y'))
    end
  end

  scenario 'Validation fails when discount price exceeds regular product price', :js do
    visit_discount_creation_page

    select 'Discount Price', from: 'Discount Type'
    fill_in 'Value', with: 60.0 # Greater than product price
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

  scenario 'Validation fails when input exceeds 100% for percentage', :js do
    visit_discount_creation_page

    select 'Percentage Reduction', from: 'Discount Type'
    fill_in 'Value', with: 120
    fill_in_discount_dates

    # Check that the field is invalid before submitting
    discount_value_field = find_field('Value')
    expect(discount_value_field[:max]).to eq('100') # Ensure the field max value is set
    expect(discount_value_field.value).to eq('120') # Ensure the input value is as entered
    expect(discount_value_field.native.attribute('validationMessage')).to eq('Value must be less than or equal to 100.')

    # Try submitting and verify the form does not proceed
    click_button 'Create Discount'
    expect(page).to have_current_path(new_artisan_product_discount_path(artisan, product)) # Form should not submit
  end

  scenario 'Product page displays multiple discounts' do
    create(:discount, product: product, discount_price: 45.0, start_date: Time.zone.today + 1, end_date: Time.zone.today + 8)
    create(:discount, product: product, discount_price: 37.0, start_date: Time.zone.today + 10, end_date: Time.zone.today + 17)

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
