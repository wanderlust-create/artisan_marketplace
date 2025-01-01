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
      # Log out the regular admin
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
      expect(current_path).to eq(auth_login_path)
    end
  end

  context 'when logged in as a super_admin' do
    before do
      # Reset session to ensure no user is logged in
      Capybara.reset_sessions!

      # Log in as a super_admin
      visit auth_login_path
      fill_in 'Email', with: super_admin.email
      fill_in 'Password', with: super_admin.password
      click_button 'Login'
    end

    it 'successfully deletes an admin from the show page after confirmation', :js do
      visit admin_path(other_admin)

      accept_confirm "Are you sure you want to delete the admin account for #{other_admin.email}?" do
        click_link 'Delete Admin Account'
      end

      expect(page).to have_content('Admin was successfully deleted.')
      expect(Admin).not_to exist(other_admin.id)
    end
  end
end
