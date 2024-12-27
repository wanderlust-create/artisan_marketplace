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

    expect(page).to have_content('Artisan Wonders')

    # Handle Turbo's confirmation modal
    accept_confirm do
      click_link 'Delete Artisan Data'
    end

    expect(page).to have_content('Artisan was successfully deleted.')
    expect(page).not_to have_content('Artisan Wonders')
  end
end
