require 'rails_helper'

RSpec.feature 'AdminCreatesArtisan', type: :feature do
  let(:admin) { Admin.find_by(email: 'admin@example.com') }
  let(:unauthorized_admin) { Admin.find_by(email: 'unauthorized_admin.com') }

  before do
    login_as(admin)
  end

  after do
    logout
  end

  scenario 'Admin navigates to the new artisan page from the artisan index' do
    visit admin_artisans_path(admin)
    expect(page).to have_link('Add New Artisan')

    click_link 'Add New Artisan'
    expect(page).to have_current_path(new_admin_artisan_path(admin))
    expect(page).to have_content('Create a New Artisan')
    expect(page).to have_field('Store Name')
    expect(page).to have_field('Email')
  end

  scenario 'Admin successfully creates a new artisan' do
    visit new_admin_artisan_path(admin)

    fill_in_artisan_form(
      store_name: 'new_artisan1',
      email: 'artisan1@example.com',
      password: 'securepassword',
      password_confirmation: 'securepassword'
    )

    click_button 'Create Artisan'

    expect(page).to have_current_path(dashboard_admin_path(admin))
    expect(page).to have_content('Artisan was successfully created.')
    expect(page).to have_content('new_artisan1')
  end

  scenario 'Admin sees all created artisans in the artisan list' do # rubocop:disable RSpec/ExampleLength
    # Create first artisan
    visit new_admin_artisan_path(admin)
    fill_in_artisan_form(
      store_name: 'new_artisan1',
      email: 'artisan1@example.com',
      password: 'securepassword',
      password_confirmation: 'securepassword'
    )
    click_button 'Create Artisan'

    # Create second artisan
    visit new_admin_artisan_path(admin)
    fill_in_artisan_form(
      store_name: 'new_artisan2',
      email: 'artisan2@example.com',
      password: 'securepassword',
      password_confirmation: 'securepassword'
    )
    click_button 'Create Artisan'

    # Verify both artisans appear on the index page
    visit admin_artisans_path(admin)
    expect(page).to have_content('new_artisan1')
    expect(page).to have_content('artisan1@example.com')
    expect(page).to have_content('new_artisan2')
    expect(page).to have_content('artisan2@example.com')
  end

  scenario 'Admin cannot create an artisan with invalid data' do
    visit new_admin_artisan_path(admin)

    fill_in_artisan_form(
      store_name: '',
      email: '',
      password: '',
      password_confirmation: ''
    )
    click_button 'Create Artisan'

    expect(page).to have_content("Store name can't be blank")
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")
  end

  scenario 'Unauthorized admin cannot access the new artisan page' do
    logout
    login_as(unauthorized_admin)

    visit new_admin_artisan_path(admin)

    expect(page).to have_current_path(dashboard_admin_path(unauthorized_admin))
    expect(page).to have_content('You do not have the necessary permissions to create this artisan.')
  end

  scenario 'Non-logged-in user is redirected to login page' do
    logout

    visit new_admin_artisan_path(admin)

    expect(page).to have_current_path(auth_login_path)
    expect(page).to have_content('You must be logged in to access this page.')
  end

  private

  def fill_in_artisan_form(store_name:, email:, password:, password_confirmation:)
    fill_in 'Store Name', with: store_name
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Confirm Password', with: password_confirmation
  end
end
