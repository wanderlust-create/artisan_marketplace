module SessionHelpers
  def login_as(user)
    visit auth_login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'
  end

  def logout
    page.driver.submit :delete, auth_logout_path, {}
  end
end
