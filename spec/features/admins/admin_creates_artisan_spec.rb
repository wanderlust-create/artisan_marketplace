require 'rails_helper'

RSpec.feature 'AdminCreatesArtisan', type: :feature do
  let(:admin) { FactoryBot.create(:admin, email: 'admin@example.com', password: 'password') }

  before do
    # Simulate admin login
    login_as(admin)
  end

  scenario 'Admin visits the artisan index page and navigates to the new artisan page' do
    visit admin_artisans_path(admin)
    expect(page).to have_content('Your Artisans') # Step 1
    expect(page).to have_link('Add New Artisan')  # Step 2

    click_link 'Add New Artisan'
    expect(page).to have_content('Create a New Artisan') # Step 3
    expect(page).to have_field('Store Name')             # Step 4
    expect(page).to have_field('Email')                  # Step 5
  end

  scenario 'Admin fills in and submits the artisan form' do
    visit admin_artisans_path(admin)
    click_link 'Add New Artisan'

    fill_in 'Store Name', with: 'Artisan Wonders' # Step 1
    fill_in 'Email', with: 'artisan@example.com'  # Step 2
    fill_in 'Password', with: 'securepassword'    # Step 3
    fill_in 'Confirm Password', with: 'securepassword' # Step 4
    click_button 'Create Artisan'                      # Step 5

    expect(page).to have_content('Artisan was successfully created.')
    expect(page).to have_content('Artisan Wonders')
    expect(page).to have_content('artisan@example.com')
  end

  scenario 'The created artisan appears in the list' do
    visit admin_artisans_path(admin)
    click_link 'Add New Artisan'

    fill_in 'Store Name', with: 'Artisan Wonders' # Step 1
    fill_in 'Email', with: 'artisan@example.com'  # Step 2
    fill_in 'Password', with: 'securepassword'    # Step 3
    fill_in 'Confirm Password', with: 'securepassword' # Step 4
    click_button 'Create Artisan'                      # Step 5

    visit admin_artisans_path(admin)
    expect(page).to have_content('Artisan Wonders') # Step 1
    expect(page).to have_content('artisan@example.com') # Step 2
  end
end
