class AdminsController < ApplicationController
  before_action :set_admin, only: %i[show edit update destroy]
  before_action :require_super_admin, only: %i[new create destroy]
  before_action :authorize_admin_edit!, only: %i[edit update]

  def index
    @admins = Admin.page(params[:page]).per(10) # Paginate for scalability
  end

  def show; end

  def new
    @admin = Admin.new
  end

  def edit; end

  def create
    @admin = Admin.new(admin_params.merge(role: 'regular')) # Ensure default role is regular

    if @admin.save
      redirect_to admins_path, notice: 'Admin was successfully created.'
    else
      render :new
    end
  end

  def update
    if @admin.update(admin_params)
      redirect_to @admin, notice: 'Admin was successfully updated.'
    else
      render :edit
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

  # Redirects unless the current user is a super_admin
  def require_super_admin
    return if session[:role] == 'super_admin'

    redirect_to root_path, alert: 'You are not authorized to perform this action.'
  end

  # Allows editing for super_admins or the admin themselves
  def authorize_admin_edit!
    return if session[:role] == 'super_admin' || current_user == @admin

    redirect_to root_path, alert: 'You are not authorized to perform this action.'
  end

  def set_admin
    @admin = Admin.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admins_path, alert: 'Admin not found.'
  end

  def admin_params
    params.require(:admin).permit(:email, :password, :password_confirmation)
  end
end
