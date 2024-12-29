require 'rails_helper'

RSpec.describe 'AdminCreatesAdmin', type: :feature do
  let(:admin) { create(:admin) } # The "system user" with permission to create admins.

  before do
    login_as(admin) # Ensure the system user (admin) is logged in.
  end

  scenario 'System user successfully creates a new admin' do
    visit new_admin_path

    fill_in 'Name', with: 'New Admin'
    fill_in 'Email', with: 'newadmin@example.com'
    fill_in 'Password', with: 'securepassword'
    fill_in 'Password confirmation', with: 'securepassword'

    click_button 'Create Admin'

    expect(page).to have_content('Admin was successfully created.')
    expect(Admin.last.email).to eq('newadmin@example.com')
  end

  scenario 'System user fails to create an admin due to validation errors' do
    visit new_admin_path

    fill_in 'Name', with: ''
    fill_in 'Email', with: 'invalidemail'
    fill_in 'Password', with: '123'
    fill_in 'Password confirmation', with: '456'

    click_button 'Create Admin'

    expect(page).to have_content('There was an error creating the admin.')
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content('Email is invalid')
    expect(page).to have_content("Password confirmation doesn't match Password")
  end
end
