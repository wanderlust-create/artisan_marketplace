require 'rails_helper'

RSpec.feature 'AdminDeletesArtisan', type: :feature do
  let(:admin) { FactoryBot.create(:admin, email: 'admin@example.com', password: 'password') }
  let!(:artisan) { FactoryBot.create(:artisan, admin: admin, store_name: 'Artisan Wonders') }

  before do
    login_as(admin)
  end

  # Rubocop is disabled for this block because the scenario needs to test multiple steps and the Artisan needs to stay deleted
  scenario 'Admin deletes an artisan and verifies it is no longer listed', :js do # rubocop:disable Metrics/BlockLength,RSpec/ExampleLength,RSpec/MultipleExpectations
    # Step 1: Navigate to the artisan show page
    visit artisan_path(artisan)
    expect(page).to have_content('Artisan Wonders')

    # Step 2: Handle Turbo's confirmation modal
    accept_confirm 'Are you sure you want to delete all data for Artisan Wonders?' do
      click_link 'Delete Data for Artisan Wonders'
    end

    # Step 3: Verify redirection and success message
    expect(page).to have_current_path(dashboard_admin_path(admin))
    expect(page).to have_content('Artisan Artisan Wonders and all associated data were successfully deleted.')

    # Step 4: Navigate to the artisan list page
    visit admin_artisans_path(admin)
    expect(page).to have_current_path(admin_artisans_path(admin))

    # Step 5: Verify artisan is no longer listed or fallback message is displayed
    if admin.artisans.any?
      within('#artisan-list') do
        expect(page).not_to have_content('Artisan Wonders')
      end
    else
      expect(page).to have_content('You currently have no artisans. Start by creating a new artisan.')
    end
  end
end
