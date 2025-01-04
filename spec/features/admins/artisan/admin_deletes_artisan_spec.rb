require 'rails_helper'

RSpec.feature 'AdminDeletesArtisan', type: :feature do
  let(:admin) { FactoryBot.create(:admin, email: 'admin@example.com', password: 'password') }
  let(:another_admin) { FactoryBot.create(:admin, email: 'anotheradmin@example.com', password: 'password') }
  let!(:artisan) { FactoryBot.create(:artisan, admin: admin, store_name: 'Artisan Wonders') }

 scenario 'Admin deletes an artisan and verifies it is no longer listed', :js do
  login_as(admin)
  
  # Ensure admin lands on their dashboard
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


  # scenario 'Another admin cannot delete the artisan', :js do
  #   login_as(another_admin)
  #   attempt_to_access_delete_path(admin, artisan)

  #   expect_to_be_redirected_with_unauthorized_message(another_admin)
  # end

  # scenario 'The artisan cannot delete herself', :js do
  #   login_as(artisan)
  #   attempt_to_access_delete_path(admin, artisan)

  #   expect_to_be_redirected_with_unauthorized_message(artisan)
  # end

  private

  # Helper to navigate to and delete an artisan
  def attempt_to_access_delete_path(admin, artisan)
    page.driver.submit :delete, admin_artisan_path(admin_id: admin.id, id: artisan.id), {}
  end

  # Helper for verifying unauthorized access redirection
  def expect_to_be_redirected_with_unauthorized_message(user)
    expect(page).to have_content('You do not have the necessary permissions to delete this artisan.')
    expect_to_be_on_dashboard_for(user)
  end

  # Helper for verifying correct dashboard redirection
  def expect_to_be_on_dashboard_for(user)
    expected_path = if user.is_a?(Admin)
                      dashboard_admin_path(user.id)
                    elsif user.is_a?(Artisan)
                      dashboard_artisan_path(user.id)
                    else
                      root_path
                    end
    expect(page).to have_current_path(expected_path)
  end
end
