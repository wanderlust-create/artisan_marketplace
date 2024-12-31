class AdminsController < ApplicationController
  before_action :set_admin, only: %i[show edit update destroy] # Fetch the admin after authorization
  before_action :require_admin, only: %i[edit update] # Ensure user is logged in first
  before_action :require_super_admin, only: %i[new create destroy] # Role-based access for super_admin
  before_action :authorize_admin_edit!, only: %i[edit update] # Permission for editing

  def index
    @admins = Admin.page(params[:page]).per(10) # Paginate for scalability
  end

  def show; end

  def new
    @admin = Admin.new
  end

  def edit
    # @admin set by before_action
  end

  def create
    @admin = Admin.new(admin_params.merge(role: 'regular')) # Ensure default role is regular

    if @admin.save
      redirect_to admins_path, notice: 'Admin was successfully created.'
    else
      render :new
    end
  end

  def update
    if unauthorized_role_change?
      handle_unauthorized_role_change
    elsif @admin.update(admin_params)
      redirect_to root_path, notice: 'Your account has been updated successfully.'
    else
      handle_update_failure
    end
  end

  def destroy
    @admin.destroy
    redirect_to admins_path, notice: 'Admin was successfully deleted.'
  end

  def dashboard
    @admin = current_user
    @artisans = @admin.artisans
  end

  private

  def require_admin
    return if current_user

    redirect_to auth_login_path, alert: 'Please log in to access your account.'
  end

  def require_super_admin
    return if session[:role] == 'super_admin'

    redirect_to root_path, alert: 'You are not authorized to edit an admin role.'
  end

  def authorize_admin_edit!
    return if session[:role] == 'super_admin' || current_user == @admin

    redirect_to root_path, alert: 'You are not authorized to edit an admin.'
  end

  def set_admin
    @admin = Admin.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admins_path, alert: 'Admin not found.'
  end

  def admin_params
    if current_user&.super_admin?
      params.require(:admin).permit(:email, :password, :password_confirmation, :role)
    else
      params.require(:admin).permit(:email, :password, :password_confirmation)
    end
  end

  def admin_role_change_attempt?
    params[:admin][:role].present? && params[:admin][:role] != @admin.role
  end

  def unauthorized_role_change?
    admin_role_change_attempt? && !current_user.super_admin?
  end

  def handle_unauthorized_role_change
    Rails.logger.warn "Unauthorized role change attempt by Admin ##{current_user.id}"
    redirect_to edit_admin_path(@admin), alert: 'You are not authorized to change your role.'
  end

  def handle_update_failure
    Rails.logger.error "Failed to update Admin ##{@admin.id}: #{@admin.errors.full_messages.join(', ')}"
    flash.now[:alert] = 'There was an error updating your account.'
    render :edit
  end
end
