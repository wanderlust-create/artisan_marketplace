class SessionsController < ApplicationController
  include SessionPermissions

  def new
    # Render the login form
  end

  def create
    user = find_user_by_email(params[:email])

    if user&.authenticate(params[:password])
      handle_user_authentication(user)
    else
      handle_login_failure
    end
  end

  def destroy
    session[:user_email] = nil
    session[:role] = nil
    redirect_to root_path, notice: 'You have logged out successfully.'
  end

  private

  def handle_user_authentication(user)
    result = verify_user_permissions(user)

    if result[:status] == :inactive
      flash[:alert] = result[:message]
      redirect_to auth_login_path(user)
    else
      log_in_user(user)
      redirect_to dashboard_path_for(user)
    end
  end

  def find_user_by_email(email)
    Admin.find_by(email: email) || Artisan.find_by(email: email)
  end

  def log_in_user(user) # rubocop:disable Metrics/AbcSize
    session[:user_email] = user.email

    if user.is_a?(Admin)
      session[:admin_id] = user.id
      session[:role] = user.super_admin? ? 'super_admin' : 'admin'
    elsif user.is_a?(Artisan)
      session[:artisan_id] = user.id
      session[:role] = 'artisan'
    else
      session[:role] = 'guest'
    end
  end

  def dashboard_path_for(user)
    if user.is_a?(Admin)
      dashboard_admin_path(user.id)
    elsif user.is_a?(Artisan)
      dashboard_artisan_path(user.id)
    else
      root_path # Default fallback
    end
  end

  def handle_login_failure
    flash.now[:alert] = 'Invalid email or password. Please try again.'
    render :new
  end
end
