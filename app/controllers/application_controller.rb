class ApplicationController < ActionController::Base
  def current_user
    # Finds the current user by their email stored in the session.
    # If new traits are added for Admin or Artisan models that affect login or session behavior,
    # ensure the session and this method are updated accordingly.
    @current_user ||= Admin.find_by(email: session[:user_email]) || Artisan.find_by(email: session[:user_email])
  end

  def dashboard_path_for(user)
    if user.is_a?(Admin)
      # Use super_admin_dashboard_path once implemented
      # return super_admin_dashboard_path if user.super_admin?
      return dashboard_admin_path(user.id)
    elsif user.is_a?(Artisan)
      return dashboard_artisan_path(user.id)
    end

    root_path # Fallback for unexpected cases
  end

  helper_method :current_user, :dashboard_path_for # Makes this method available in views
end
