require 'rails_helper'

RSpec.describe 'Delete an Admin', type: :feature do
  let(:super_admin) { create(:admin, role: 'super_admin') }
  let(:admin) { create(:admin, role: 'regular') }
  let(:other_admin) { create(:admin, role: 'regular') }

  context 'when logged in as a regular admin' do
    before do
      visit auth_login_path
      fill_in 'Email', with: admin.email
      fill_in 'Password', with: admin.password
      click_button 'Login'
    end

    after do
      # Log out after this context
      click_link 'Logout'
    end

    it 'does not allow a regular admin to delete another admin' do
      visit admin_path(other_admin)

      expect(page).not_to have_button('Delete Admin')
    end
  end

  context 'when not logged in' do
    it 'redirects to the login page when trying to delete an admin' do
      page.driver.submit :delete, admin_path(other_admin), {}

      expect(page).to have_content('Please log in to access your account.')
      expect(current_path).to eq(login_path)
    end
  end

  context 'when logged in as a super_admin' do
    before do
      visit auth_login_path
      fill_in 'Email', with: super_admin.email
      fill_in 'Password', with: super_admin.password
      click_button 'Login'
    end

    it 'successfully deletes an admin from the show page after confirmation' do
      visit admin_path(other_admin)

      click_button 'Delete Admin'

      # Simulate confirmation dialog
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content('Admin was successfully deleted.')
      expect(Admin).not_to exist(other_admin.id)
    end
  end
end
