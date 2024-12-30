class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= Admin.find_by(id: session[:user_id]) || Artisan.find_by(id: session[:user_id])
  end
end
