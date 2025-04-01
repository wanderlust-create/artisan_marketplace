module SessionHelpers
  def login_as(user, password: 'password')

    # binding.pry

    visit auth_login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: password
    click_button 'Login'
  end

  def logout
    page.driver.submit :delete, auth_logout_path, {}
  end
end
