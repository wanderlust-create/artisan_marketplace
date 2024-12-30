require 'rails_helper'

RSpec.feature 'AdminCreatesArtisan', type: :feature do
  let(:admin) { FactoryBot.create(:admin, email: 'admin@example.com', password: 'password') }

  before do
    login_as(admin) # Simulate admin login
  end

  scenario 'Admin navigates to the new artisan page from the index' do # rubocop:disable RSpec/MultipleExpectations
    # Step 1: Visit the artisan index page
    visit admin_artisans_path(admin)
    expect(page).to have_content('Your Artisans')
    expect(page).to have_link('Add New Artisan')

    # Step 2: Click the link and verify navigation
    click_link 'Add New Artisan'
    expect(page).to have_current_path(new_admin_artisan_path(admin)) # URI expectation
    expect(page).to have_content('Create a New Artisan')
    expect(page).to have_field('Store Name')
    expect(page).to have_field('Email')
  end

  scenario 'Admin fills in the form and creates a new artisan' do
    # Step 1: Navigate to the new artisan form
    visit new_admin_artisan_path(admin)

    # Step 2: Fill in the form
    fill_in 'Store Name', with: 'Artisan Wonders'
    fill_in 'Email', with: 'artisan@example.com'
    fill_in 'Password', with: 'securepassword'
    fill_in 'Confirm Password', with: 'securepassword'

    # Step 3: Submit the form
    click_button 'Create Artisan'

    # Step 4: Verify redirection and success message
    expect(page).to have_current_path(dashboard_admin_path(admin)) # URI expectation
    expect(page).to have_content('Artisan was successfully created.')
    expect(page).to have_content('Artisan Wonders')
  end

  scenario 'Admin sees the newly created artisan in the list' do
    # Step 1: Create the artisan
    visit new_admin_artisan_path(admin)
    fill_in 'Store Name', with: 'Artisan Wonders'
    fill_in 'Email', with: 'artisan@example.com'
    fill_in 'Password', with: 'securepassword'
    fill_in 'Confirm Password', with: 'securepassword'
    click_button 'Create Artisan'

    # Step 2: Verify redirection to the dashboard
    expect(page).to have_current_path(dashboard_admin_path(admin))

    # Step 3: Navigate to the artisan index page
    visit admin_artisans_path(admin)

    # Step 4: Verify the artisan appears in the list
    expect(page).to have_content('Artisan Wonders')
    expect(page).to have_content('artisan@example.com')
  end
end
