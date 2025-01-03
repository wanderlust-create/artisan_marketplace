require 'rails_helper'

RSpec.describe 'Admin Views Artisan', type: :feature do
  let(:super_admin) { create(:admin, role: 'super_admin') }
  let(:admin) { create(:admin) }
  let(:other_admin) { create(:admin) }
  let(:artisan) { create(:artisan, admin: admin) }

  context 'when logged in as the artisan owner' do
    before { login_as(admin) }

    after do
      click_link 'Logout'
    end

    it 'shows the artisan details with edit and delete links' do
      visit artisan_path(artisan)

      expect(page).to have_content(artisan.store_name)
      expect(page).to have_content(artisan.email)
      expect(page).to have_link('Edit Artisan Data')
      expect(page).to have_link("Delete Data for #{artisan.store_name}")
    end
  end

  context 'when logged in as a super admin' do
    before { login_as(super_admin) }

    after do
      click_link 'Logout'
    end

    it 'shows the artisan details with edit and delete links' do
      visit artisan_path(artisan)

      expect(page).to have_content(artisan.store_name)
      expect(page).to have_content(artisan.email)
      expect(page).to have_link('Edit Artisan Data')
      expect(page).to have_link("Delete Data for #{artisan.store_name}")
    end
  end

  context 'when logged in as a different admin' do
    before { login_as(other_admin) }

    after do
      click_link 'Logout'
    end

    it 'shows the artisan details but no edit or delete links' do
      visit artisan_path(artisan)

      expect(page).to have_content(artisan.store_name)
      expect(page).to have_content(artisan.email)
      expect(page).not_to have_link('Edit Artisan Data')
      expect(page).not_to have_link("Delete Data for #{artisan.store_name}")
    end
  end

  context 'when logged in as the artisan' do
    before { login_as(artisan) }

    after do
      click_link 'Logout'
    end

    it 'shows the artisan details with an edit link but no delete link' do
      visit artisan_path(artisan)

      expect(page).to have_content(artisan.store_name)
      expect(page).to have_content(artisan.email)
      expect(page).to have_link('Edit Artisan Data')
      expect(page).not_to have_link("Delete Data for #{artisan.store_name}")
    end
  end

  context 'when not logged in' do
    it 'redirects to the login page' do
      visit artisan_path(artisan)

      expect(page).to have_content('You must be logged in to access this page.')
      expect(current_path).to eq(auth_login_path)
    end
  end
end
