require 'rails_helper'

RSpec.feature 'ArtisanEditsAccount', type: :feature do
  let!(:admin) { FactoryBot.create(:admin, email: 'admin@example.com', password: 'password') }
  # let(:artisan) { FactoryBot.create(:artisan, store_name: 'Artisan Wonders', email: 'artisan@example.com', password: 'password') }
  let(:artisan) { FactoryBot.create(:artisan, admin: admin, store_name: 'Artisan Wonders', email: 'artisan@example.com') }

  scenario 'Artisan edits their account details and verifies changes', :js do
    # Log in as the artisan
    login_as(artisan)
    expect_to_be_on_dashboard_for(artisan)

    # Navigate to the account edit page
    navigate_to_edit_page

    # Update account details
    update_account_details

    # Verify success message
    verify_success_message

    # Verify updated details
    verify_updated_details
  end

  scenario 'Artisan attempts to access and edit account status', :js do
    # Log in as the artisan
    login_as(artisan)
    expect_to_be_on_dashboard_for(artisan)

    # Navigate to the account edit page
    visit artisan_path(artisan)
    click_link 'Edit Artisan Data'
    expect(page).to have_current_path(edit_admin_artisan_path(admin, artisan))

    # Verify account status field is not visible
    expect(page).not_to have_field('Account Status')
  end

  # Inline steps
  def navigate_to_edit_page
    click_link 'Show My Details'
    expect(page).to have_current_path(artisan_path(artisan))
    click_link 'Edit Artisan Data'
    expect(page).to have_current_path(edit_admin_artisan_path(admin, artisan))
  end

  def update_account_details
    fill_in 'Store Name', with: 'Updated Artisan Wonders'
    fill_in 'Email', with: 'updated_artisan@example.com'
    fill_in 'Password (leave blank if unchanged)', with: 'newpassword123'
    fill_in 'Confirm Password', with: 'newpassword123'
    click_button 'Update Artisan'
  end

  def verify_success_message
    expect(page).to have_current_path(artisan_path(artisan))
    expect(page).to have_content('Artisan details have been successfully updated.')
  end

  def verify_updated_details
    expect(page).to have_content('Updated Artisan Wonders')
    expect(artisan.reload.email).to eq('updated_artisan@example.com')
  end
end
