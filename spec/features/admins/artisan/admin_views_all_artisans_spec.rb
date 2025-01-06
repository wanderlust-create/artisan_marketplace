require 'rails_helper'

RSpec.feature 'AdminViewsAllArtisans', type: :feature do
  let!(:admin) { FactoryBot.create(:admin, email: 'admin@example.com', password: 'password') }
  let!(:another_admin) { FactoryBot.create(:admin, email: 'other_admin@example.com', password: 'password') }

  # Create multiple artisans dynamically for the admin
  let!(:my_artisans) do
    FactoryBot.create_list(:artisan, 5, admin: admin)
  end

  # Create multiple artisans for another admin
  let!(:other_artisans) do
    FactoryBot.create_list(:artisan, 3, admin: another_admin)
  end

  scenario 'Admin views their own artisans with full actions', :js do
    # Log in as the admin
    login_as(admin)
    expect_to_be_on_dashboard_for(admin)
    click_link 'View All Artisans'
    expect(page).to have_current_path(admin_artisans_path(admin))

    # Verify "My Artisans" are displayed
    my_artisans.each do |artisan|
      within("#artisan-#{artisan.id}") do
        expect(page).to have_content(artisan.store_name)
        expect(page).to have_content(artisan.email)
        expect(page).to have_link('Show', href: artisan_path(artisan))
        expect(page).to have_link('Edit', href: edit_admin_artisan_path(admin, artisan))
        expect(page).not_to have_link('Delete')
      end
    end
  end

  scenario 'Admin views other admins artisans with restricted actions', :js do
    # Log in as the admin
    login_as(admin)
    expect_to_be_on_dashboard_for(admin)
    click_link 'View All Artisans'
    expect(page).to have_current_path(admin_artisans_path(admin))

    # Toggle the "Other Artisans" section to view it
    click_button 'Toggle View'
    expect(page).to have_selector('#other-artisans-list', visible: true)

    # Verify "Other Artisans" are displayed
    other_artisans.each do |artisan|
      within("#artisan-#{artisan.id}") do
        expect(page).to have_content(artisan.store_name)
        expect(page).to have_content(artisan.email)
        expect(page).to have_link('Show', href: artisan_path(artisan))
        expect(page).not_to have_link('Edit')
        expect(page).not_to have_link('Delete')
      end
    end
  end

  scenario 'Admin sees a message if no artisans are found', :js do
    # Create a new admin with no artisans
    empty_admin = FactoryBot.create(:admin, email: 'empty_admin@example.com', password: 'password')
    login_as(empty_admin)
    visit admin_artisans_path(empty_admin)

    # Verify message is displayed
    expect(page).to have_content('No artisans found. Create your first artisan!')
  end
end
