class SessionsController < ApplicationController
  def new
    # Render the login form
  end

  def create
    user = find_user_by_email(params[:email])

    if user&.authenticate(params[:password])
      log_in_user(user)
      redirect_to dashboard_path_for(user)
    else
      handle_login_failure
    end
  end

  def destroy
    session[:user_id] = nil
    session[:role] = nil
    redirect_to root_path, notice: 'You have logged out successfully.'
  end

  private

  def find_user_by_email(email)
    Admin.find_by(email: email) || Artisan.find_by(email: email)
  end

  def log_in_user(user)
    session[:user_id] = user.id
    session[:role] = user.role if user.is_a?(Admin) # Save role if user is an admin
  end

  def handle_login_failure
    flash.now[:alert] = 'Invalid email or password. Please try again.'
    render :new
  end
end
