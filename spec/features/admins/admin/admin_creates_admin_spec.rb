require 'rails_helper'

RSpec.describe 'Admin Creates Admin', type: :feature do
  let(:super_admin) { create(:admin, role: 'super_admin') }
  let(:regular_admin) { create(:admin, role: 'regular') }

  context 'when logged in as a super admin' do
    before { login_as(super_admin) }

    it 'successfully creates a new admin' do
      visit new_admin_path

      fill_in 'Email', with: 'newadmin@example.com'
      fill_in 'Password', with: 'securepassword'
      fill_in 'Confirm Password', with: 'securepassword'

      click_button 'Create Admin'

      expect(page).to have_content('Admin was successfully created.')
      expect(Admin.last.email).to eq('newadmin@example.com')
      expect(Admin.last.role).to eq('regular')
    end

    it 'fails to create an admin due to validation errors' do
      visit new_admin_path

      fill_in 'Email', with: 'invalidemail'
      fill_in 'Password', with: '123'
      fill_in 'Confirm Password', with: '456'

      click_button 'Create Admin'

      expect(page).to have_content('There was an error creating the admin')
      expect(page).to have_content('Email must be a valid email address')
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end

  context 'when logged in as a regular admin' do
    before do
      logout
      login_as(regular_admin)
    end

    it 'cannot access the admin creation page' do
      visit new_admin_path

      expect(page).to have_content('You do not have the necessary permissions to perform this action.')
      expect(current_path).to eq(root_path)
    end
  end
end
