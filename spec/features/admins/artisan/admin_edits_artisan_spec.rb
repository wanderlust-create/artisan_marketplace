require 'rails_helper'

RSpec.feature 'AdminEditsArtisan', type: :feature do
  let(:super_admin) { FactoryBot.create(:admin, email: 'superadmin@example.com', password: 'password', role: 'super_admin') }
  let(:admin) { FactoryBot.create(:admin, email: 'admin@example.com', password: 'password') }
  let(:unauthorized_admin) { FactoryBot.create(:admin, email: 'unauthorizedadmin@example.com', password: 'password') }
  let!(:artisan) { FactoryBot.create(:artisan, admin: admin, store_name: 'Artisan Wonders', email: 'artisan@example.com') }

  scenario 'Super admin edits an artisan and verifies changes', :js do
    login_as(super_admin)
    expect_to_be_on_dashboard_for(super_admin)

    navigate_to_artisan_edit_page(admin: admin, artisan: artisan)
    update_artisan_details(store_name: 'Updated Artisan Wonders', email: 'updated_artisan@example.com', status: 'Inactive')
    verify_success_message_deactivated
    verify_updated_details(artisan: artisan, store_name: 'Updated Artisan Wonders', email: 'updated_artisan@example.com', status: false)
  end

  scenario 'Admin edits their own artisan and verifies changes', :js do
    login_as(admin)
    expect_to_be_on_dashboard_for(admin)

    navigate_to_artisan_edit_page(admin: admin, artisan: artisan)
    update_artisan_details(store_name: 'Updated Artisan Wonders', email: 'updated_artisan@example.com', status: 'Active')
    verify_success_message_reactivated
    verify_updated_details(artisan: artisan, store_name: 'Updated Artisan Wonders', email: 'updated_artisan@example.com', status: true)
  end

  scenario 'Unauthorized admin attempts to edit artisan and is redirected', :js do
    login_as(unauthorized_admin)
    expect_to_be_on_dashboard_for(unauthorized_admin)

    navigate_to_artisan_show_page(admin: admin, artisan: artisan)
    expect(page).not_to have_link('Edit Artisan Data')

    attempt_unauthorized_edit(admin: admin, artisan: artisan)
  end

  # Helper Methods

  def navigate_to_artisan_show_page(admin:, artisan:)
    visit admin_artisans_path(admin)
    click_link 'Show Artisan Wonders'
    expect(page).to have_current_path(artisan_path(id: artisan.id))
  end

  def navigate_to_artisan_edit_page(admin:, artisan:)
    navigate_to_artisan_show_page(admin: admin, artisan: artisan)
    click_link 'Edit Artisan Data'
    expect(page).to have_current_path(edit_admin_artisan_path(admin_id: admin.id, id: artisan.id))
  end

  def update_artisan_details(store_name:, email:, status:)
    fill_in 'Store Name', with: store_name
    fill_in 'Email', with: email
    select status, from: 'Account Status'
    click_button 'Update Artisan'
  end

  def verify_success_message_deactivated
    expect(page).to have_content('Artisan has been successfully deactivated. Artisan details have been successfully updated.')
  end

  def verify_success_message_reactivated
    expect(page).to have_content('Artisan has been successfully reactivated. Artisan details have been successfully updated.')
  end

  def verify_updated_details(artisan:, store_name:, email:, status:)
    visit artisan_path(artisan)
    expect(page).to have_content(store_name)
    expect(artisan.reload.email).to eq(email)
    expect(artisan.reload.active).to eq(status)
  end

  def attempt_unauthorized_edit(admin:, artisan:)
    visit edit_admin_artisan_path(admin_id: admin.id, id: artisan.id)
    expect(page).to have_current_path(artisan_path(artisan))
    expect(page).to have_content('You do not have the necessary permissions to edit this artisan.')
  end
end
