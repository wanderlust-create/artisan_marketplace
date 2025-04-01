require 'rails_helper'

RSpec.describe 'Admin Creates Admin', :js, type: :feature do
  let!(:super_admin) { Admin.find_by(email: 'superadmin@example.com') }
  let!(:regular_admin) { Admin.find_by(email: 'admin@example.com') }

  context 'when logged in as a super admin' do
    before { login_as(super_admin, password: 'password') }

    # it 'successfully creates a new admin' do
    #   visit new_admin_path

    #   fill_in 'Email', with: 'newadmin@example.com'
    #   fill_in 'Password', with: 'securepassword'
    #   fill_in 'Confirm Password', with: 'securepassword'

    #   click_button 'Create Admin'
    #   expect(page.body).to include('novalidate')

    #   expect(page).to have_content('Admin was successfully created.')
    #   expect(Admin.last.email).to eq('newadmin@example.com')
    #   expect(Admin.last.role).to eq('regular')
    # end

    scenario 'fails to create an admin due to validation errors', :js do
      visit new_admin_path

      fill_in 'Email', with: 'invalid@email.com'
      fill_in 'Password', with: '123'
      fill_in 'Confirm Password', with: '456'
      # sleep 2 # <-- click the browser window during this pause
      page.execute_script('document.querySelector("form").removeAttribute("novalidate")')

      click_button 'Create Admin'
      puts page.body

      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end

  # context 'when logged in as a regular admin' do
  #   before do
  #     logout
  #     login_as(regular_admin, password: 'password')
  #   end

  #   it 'cannot access the admin creation page' do
  #     visit new_admin_path

  #     expect(page).to have_content('You do not have the necessary permissions to perform this action.')
  #     expect(current_path).to eq(root_path)
  #   end
  # end
end
