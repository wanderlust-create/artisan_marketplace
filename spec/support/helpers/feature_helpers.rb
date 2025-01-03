module FeatureHelpers
  def toggle_account_status(status)
    select status, from: 'Account Status'
    click_button 'Update Artisan'
  end
end
