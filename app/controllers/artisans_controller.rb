class ArtisansController < ApplicationController
  before_action :require_login
  before_action :set_admin, only: %i[index show new create edit update destroy]
  before_action :set_artisan, only: %i[show update destroy]
  before_action :authorize_artisan_access, only: %i[edit update]
  helper_method :can_edit_artisan?, :can_view_artisan?, :can_delete_artisan?

  def index
    @artisans = @admin.artisans
  end

  def show
    # @artisan is set via before_action
  end

  def new
    @artisan = @admin.artisans.build
  end

  def create
    @artisan = @admin.artisans.build(artisan_params)

    if @artisan.save
      redirect_to dashboard_admin_path(@admin), notice: 'Artisan was successfully created.'
    else
      render :new
    end
  end

  def edit
    # @artisan is already set via before_action
  end

  def update
    if @artisan.update(artisan_params)
      handle_status_change
      @artisan.save
      redirect_to artisan_path(@artisan), notice: flash[:notice]
    else
      flash.now[:alert] = 'There was an error updating the artisan.'
      render :edit
    end
  end

  def destroy
    store_name = @artisan.store_name
    if @artisan.destroy

      redirect_to dashboard_admin_path(@admin), notice: "Artisan #{store_name} and all associated data were successfully deleted."
    else
      redirect_to dashboard_admin_path(@admin), alert: "Failed to delete Artisan #{store_name}."
    end
  end

  def dashboard
    @artisan = Artisan.find(params[:id])
    @products = @artisan.products
  end

  def can_edit_artisan?
    # binding.pry
    current_user == @artisan || current_user == @artisan.admin || current_user.super_admin?
  end

  def can_delete_artisan?
    if current_user.is_a?(Admin)
      current_user.super_admin? || current_user == @artisan.admin
    elsif current_user.is_a?(Artisan)
      false # Artisans should not have permission to delete
    else
      false # Default to no permission
    end
  end

  def can_view_artisan?
    current_user.is_a?(Admin) || current_user == @artisan
  end

  private

  def require_login
    return if current_user

    redirect_to auth_login_path, alert: 'You must be logged in to access this page.'
  end

  def set_admin
    if params[:admin_id]
      # When `admin_id` is explicitly provided (e.g., during creation)
      @admin = Admin.find(params[:admin_id])
    elsif params[:id]
      # When showing or editing an artisan, use the foreign key on the artisan
      @admin = Artisan.find(params[:id]).admin
    else
      raise ActiveRecord::RecordNotFound, 'Admin could not be determined'
    end
  end

  def authorize_artisan_access
    return if can_edit_artisan?

    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to artisan_path(@artisan)
  end

  def set_artisan
    @artisan = Artisan.find(params[:id])
  end

  def artisan_params
    params.require(:artisan).permit(:store_name, :email, :password, :password_confirmation, :active)
  end

  def handle_status_change
    flash[:notice] = if artisan_params[:active].present?
                       "Artisan has been successfully #{artisan_params[:active] == 'true' ? 'reactivated' : 'deactivated'}."
                     else
                       'Artisan details have been successfully updated.'
                     end
  end
end
