require 'rails_helper'

RSpec.feature 'AdminDeletesArtisan', type: :feature do
  let(:admin) { FactoryBot.create(:admin, email: 'admin@example.com', password: 'password') }

  before do
    FactoryBot.create(:artisan, admin: admin, store_name: 'Artisan Wonders')
    login_as(admin)
  end

  scenario 'Admin visits the artisans list page' do
    visit admin_path(admin)
    expect(page).to have_content('Artisan Wonders')
  end

  scenario 'Admin deletes an artisan with Turbo confirmation', :js do
    visit admin_path(admin)

    # Check that the artisan is listed
    expect(page).to have_content('Artisan Wonders')

    # Handle Turbo's confirmation modal
    accept_confirm 'Are you sure you want to delete all data for Artisan Wonders?' do
      click_link 'Delete Data for Artisan Wonders'
    end

    # Check for success message
    expect(page).to have_content('Artisan Artisan Wonders and all associated data were successfully deleted.')

    # Verify artisan list or fallback message
    if admin.artisans.any?
      within('#artisan-list') do
        expect(page).not_to have_content('Artisan Wonders')
      end
    else
      expect(page).to have_content('No artisans yet. Start by creating a new artisan.')
    end
  end
end
