module FeatureHelpers
  def toggle_account_status(status)
    select status, from: 'Account Status'
    click_button 'Update Artisan'
  end

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
