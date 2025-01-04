require 'rails_helper'

RSpec.describe 'Admin Edits Their Own Account', type: :feature do
  let(:admin) { create(:admin, email: 'oldemail@example.com', password: 'oldpassword') }
  let(:other_admin) { create(:admin, email: 'otheradmin@example.com') }

  context 'when logged in as an admin' do
    before { login_as(admin) }

    it 'successfully updates their account details' do
      visit edit_admin_path(admin)

      fill_in 'Email', with: 'newemail@example.com'
      fill_in 'New Password (leave blank to keep current password)', with: 'newpassword'
      fill_in 'Confirm Password', with: 'newpassword'
      click_button 'Update Account'

      expect(page).to have_content('Your account has been updated successfully.')
      expect(admin.reload.email).to eq('newemail@example.com')
    end

    it 'does not allow a regular admin to change their role' do
      visit edit_admin_path(admin)

      page.driver.submit :patch, admin_path(admin), { admin: { role: 'super_admin' } }

      expect(page).to have_content('You do not have the necessary permissions to change this role.')
      expect(admin.reload.role).to eq('regular') # Role remains unchanged
    end

    it 'displays validation errors for invalid fields' do
      visit edit_admin_path(admin)

      fill_in 'Email', with: '' # Invalid email
      click_button 'Update Account'

      expect(page).to have_content('There was an error updating your account.')
      expect(page).to have_content("Email can't be blank")
    end
  end

  context 'when not logged in' do
    it 'redirects to the login page' do
      logout
      expect(page).to have_content('You have logged out successfully.')
      visit edit_admin_path(admin)
      expect(page).to have_content('Please log in to access your account.')
      expect(page).to have_button('Login')
    end
  end
end
