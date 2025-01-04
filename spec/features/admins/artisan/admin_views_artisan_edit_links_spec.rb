require 'rails_helper'

RSpec.describe 'Admin Deactivates/Reactivates an Artisan', type: :feature do
  let(:admin) { create(:admin) }
  let(:other_admin) { create(:admin) }
  let!(:artisan) { create(:artisan, store_name: 'Test Store', email: 'artisan@example.com', admin: admin) }

  context 'when logged in as the admin who owns the artisan' do
    before do
      login_as(admin)
      visit edit_admin_artisan_path(admin, artisan)
    end

    after { click_link 'Logout' }

    it 'successfully deactivates the artisan account' do
      toggle_account_status('Inactive')

      expect(page).to have_content('Artisan has been successfully deactivated.')
      expect(current_path).to eq(artisan_path(artisan))
      expect(artisan.reload.active).to be_falsey
    end

    it 'successfully reactivates the artisan account' do
      artisan.update(active: false)

      toggle_account_status('Active')

      expect(page).to have_content('Artisan has been successfully reactivated.')
      expect(current_path).to eq(artisan_path(artisan))
      expect(artisan.reload.active).to be_truthy
    end
  end

  context 'when logged in as a different admin' do
    before { login_as(other_admin) }
    after { click_link 'Logout' }

    it 'redirects with an unauthorized message' do
      visit edit_admin_artisan_path(admin, artisan)

      expect(page).to have_content('You do not have the necessary permissions to edit this artisan.')
      expect(current_path).to eq(artisan_path(artisan))
    end
  end

  context 'when not logged in' do
    it 'redirects to the login page' do
      visit edit_admin_artisan_path(admin, artisan)

      expect(page).to have_content('You must be logged in to access this page.')
      expect(current_path).to eq(auth_login_path)
    end
  end
end
