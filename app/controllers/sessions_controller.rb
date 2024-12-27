class SessionsController < ApplicationController
  def new
    # Render the login form
  end

  def create
    user = find_user_by_email

    if authenticate_user(user)
      log_in_user(user)
      redirect_to dashboard_path_for(user)
    else
      handle_login_failure
    end
  end

  def destroy
    session[:user_id] = nil
    session[:user_type] = nil
    redirect_to root_path, notice: 'Logged out successfully'
  end

  private

  # TODO: - unique email is not checked across both Admin & Artisan dbs. This will always log in as Admin. Need to find a way to add a unique email across both databases
  def find_user_by_email
    Admin.find_by(email: params[:email]) || Artisan.find_by(email: params[:email])
  end

  def authenticate_user(user)
    user&.authenticate(params[:password])
  end

  def log_in_user(user)
    session[:user_id] = user.id
    session[:user_type] = user.class.name.downcase
  end

  def dashboard_path_for(user)
    user.is_a?(Admin) ? admin_path(user.id) : artisan_path(user.id)
  end

  def handle_login_failure
    flash.now[:alert] = 'Invalid email or password'
    render :new
  end
end
