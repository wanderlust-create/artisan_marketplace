require 'rails_helper'

RSpec.feature 'AdminCreatesArtisan', type: :feature do
  let(:admin) { FactoryBot.create(:admin, email: 'admin@example.com', password: 'password') }

  before do
    # Simulate admin login
    login_as_admin(admin)
  end

  scenario 'Admin visits the new artisan page' do
    visit new_admin_artisan_path(admin)
    expect(page).to have_content('Create a New Artisan')
    expect(page).to have_field('Store Name')
    expect(page).to have_field('Email')
    expect(page).to have_field('Password')
  end

  scenario 'Admin fills in and submits the artisan form' do
    create_artisan('Artisan Wonders', 'artisan@example.com', 'securepassword')
    expect(page).to have_content('Artisan was successfully created.')
    expect(page).to have_content('Artisan Wonders')
    expect(page).to have_content('artisan@example.com')
  end

  scenario 'The created artisan appears in the list' do
    create_artisan('Artisan Wonders', 'artisan@example.com', 'securepassword')
    visit admin_artisans_path(admin)
    expect(page).to have_content('Artisan Wonders')
    expect(page).to have_content('artisan@example.com')
  end

  private

  def login_as_admin(admin)
    visit auth_login_path
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: admin.password
    click_button 'Login'
  end

  def create_artisan(store_name, email, password)
    visit new_admin_artisan_path(admin)
    fill_in 'Store Name', with: store_name
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Confirm Password', with: password
    click_button 'Create Artisan'
  end
end
