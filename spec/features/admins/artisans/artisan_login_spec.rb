require 'rails_helper'

RSpec.describe 'Artisan Login', type: :feature do
  let(:active_artisan) { create(:artisan, email: 'active@example.com', password: 'password', active: true) }
  let(:inactive_artisan) { create(:artisan, email: 'inactive@example.com', password: 'password', active: false) }

  it 'allows active artisans to log in' do
    # Custom helper method to log in as the specified artisan
    login_as(active_artisan)

    welcome_message = "Welcome, #{active_artisan.store_name}!"
    expect(page).to have_content(welcome_message)
    expect(page).to have_content("Welcome, #{active_artisan.store_name}!")
  end

  it 'prevents inactive artisans from logging in' do
    # Custom helper method to log in as the specified artisan
    login_as(inactive_artisan)
    deactivated_message = 'Your account has been deactivated. Please contact your administrator.'
    expect(page).to have_content(deactivated_message)
    expect(page).to have_content('Your account has been deactivated. Please contact your administrator.')
  end
end
