require 'rails_helper'

RSpec.feature 'AdminDeletesArtisan', type: :feature do
  let(:admin) { FactoryBot.create(:admin, email: 'admin@example.com', password: 'password') }
  let(:another_admin) { FactoryBot.create(:admin, email: 'anotheradmin@example.com', password: 'password') }
  let!(:artisan) { FactoryBot.create(:artisan, admin: admin, store_name: 'Artisan Wonders') }

  scenario 'Admin deletes an artisan and verifies it is no longer listed', :js do
    login_as(admin)
    expect_to_be_on_dashboard_for(admin)

    # Navigate to the artisan show page
    click_link 'Artisan Wonders'
    expect(page).to have_current_path(artisan_path(artisan))

    # Confirm deletion and verify success message
    accept_confirm 'Are you sure you want to delete all data for Artisan Wonders?' do
      click_link 'Delete Data for Artisan Wonders'
    end
    expect(page).to have_content('Artisan Wonders and all associated data were successfully deleted.')

    # Verify artisan is no longer listed
    visit admin_artisans_path(admin)
    expect(page).not_to have_content('Artisan Wonders')
  end

  scenario 'Another admin can view but cannot delete the artisan', :js do
    login_as(another_admin)
    expect_to_be_on_dashboard_for(another_admin)

    # Navigate to the artisan page
    visit artisan_path(artisan)
    expect(page).not_to have_link('Delete Data for Artisan Wonders')
  end

  scenario 'The artisan can view but cannot delete herself', :js do
    login_as(artisan)
    expect_to_be_on_dashboard_for(artisan)

    # Navigate to their own show page
    visit artisan_path(artisan)
    expect(page).not_to have_link('Delete Data for Artisan Wonders')
  end
end
