module SessionHelpers
  def login_as(_user)
    visit auth_login_path
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: admin.password
    click_button 'Login'
  end
end
