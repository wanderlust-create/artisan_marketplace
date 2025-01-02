require 'rails_helper'

RSpec.describe 'Admin Deactivates/Reactivates an Artisan', type: :feature do
  let(:admin) { create(:admin) }
  let(:other_admin) { create(:admin) }
  let!(:artisan) { create(:artisan, store_name: 'Test Store', email: 'artisan@example.com', admin: admin) }

  context 'when logged in as the admin who owns the artisan' do
    before do
      login_as(admin)
    end

    after do
      click_link 'Logout'
    end

    it 'successfully deactivates the artisan account' do
      visit edit_admin_artisan_path(admin, artisan)

      # Toggle to deactivate
      select 'Inactive', from: 'Account Status'
      click_button 'Update Artisan'

      expect(page).to have_content('Artisan has been successfully deactivated.')
      expect(current_path).to eq(admin_artisan_path(admin, artisan))
      expect(artisan.reload.active).to be_falsey
    end

    it 'successfully reactivates the artisan account' do
      # Deactivate the artisan first
      artisan.update(active: false)
      visit edit_admin_artisan_path(admin, artisan)

      # Toggle to reactivate
      select 'Active', from: 'Account Status'
      click_button 'Update Artisan'

      expect(page).to have_content('Artisan has been successfully reactivated.')
      expect(current_path).to eq(admin_artisan_path(admin, artisan))
      expect(artisan.reload.active).to be_truthy
    end
  end

  context 'when logged in as a different admin' do
    before do
      login_as(other_admin)
    end

    after do
      click_link 'Logout'
    end

    it 'redirects with an unauthorized message' do
      visit edit_admin_artisan_path(admin, artisan)

      expect(page).to have_content('You are not authorized to perform this action.')
      expect(current_path).to eq(root_path)
    end
  end

  context 'when not logged in' do
    it 'redirects to the login page' do
      visit edit_admin_artisan_path(admin, artisan)

      expect(page).to have_content('Please log in to access your account.')
      expect(current_path).to eq(auth_login_path)
    end
  end
end
