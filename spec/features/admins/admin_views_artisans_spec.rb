require 'rails_helper'

RSpec.describe 'View All Artisans', type: :feature do
  let(:admin) { create(:admin) }
  let!(:artisan1) { create(:artisan, store_name: 'Artisan One', email: 'artisan1@example.com', admin: admin) }
  let!(:artisan2) { create(:artisan, store_name: 'Artisan Two', email: 'artisan2@example.com', admin: admin) }

  context 'when logged in as an admin' do
    before do
      login_as(admin)
      visit admin_artisans_path(admin)
    end

    it 'displays a list of all artisans with their details' do
      expect(page).to have_content('Artisan One')
      expect(page).to have_content('artisan1@example.com')
      expect(page).to have_content('Artisan Two')
      expect(page).to have_content('artisan2@example.com')
    end

    it 'shows "Edit" and "Delete" buttons for each artisan' do
      within("#artisan-#{artisan1.id}") do
        expect(page).to have_link('Edit', href: edit_admin_artisan_path(admin, artisan1))
        expect(page).to have_link('Delete', href: admin_artisan_path(admin, artisan1))
      end

      within("#artisan-#{artisan2.id}") do
        expect(page).to have_link("Show #{artisan2.store_name}", artisan_path(artisan2))
        expect(page).to have_link("Edit #{artisan2.store_name}", edit_admin_artisan_path(admin, artisan2))
   
      end
    end
  end

  context 'when not logged in' do
    it 'redirects to the login page' do
      visit admin_artisans_path(admin)

      expect(page).to have_content('Please log in to access your account.')
      expect(current_path).to eq(auth_login_path)
    end
  end
end
