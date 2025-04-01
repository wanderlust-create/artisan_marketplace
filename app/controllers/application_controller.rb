class ApplicationController < ActionController::Base
  def current_user
    if session[:admin_id]
      @current_user ||= Admin.find_by(id: session[:admin_id])
    elsif session[:artisan_id]
      @current_user ||= Artisan.find_by(id: session[:artisan_id])
    end
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

  helper_method :current_user, :dashboard_path_for
end
