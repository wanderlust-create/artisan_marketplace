module ApplicationHelper
  def dashboard_path_for(user)
    return root_path unless user

    if user.is_a?(Admin)
      # TODO: Update to super_admin_dashboard_path after it has been built
      dashboard_admin_path(user.id)
    elsif user.is_a?(Artisan)
      dashboard_artisan_path(user.id)
    else
      root_path
    end
  end
end
