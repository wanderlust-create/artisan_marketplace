class ArtisansController < ApplicationController
  include ArtisanPermissions
  before_action :require_login
  before_action :set_admin, only: %i[index show new create edit update destroy]
  before_action :set_artisan, only: %i[show edit update destroy dashboard]
  before_action :authorize_edit_artisan, only: %i[edit update]
  before_action :authorize_create_artisan, only: %i[new create]
  before_action :authorize_delete_artisan, only: %i[destroy]

  helper_method :can_manage_artisan?, :can_view_artisan?

  # Actions

  def index
    @my_artisans = @admin.artisans # Artisans belonging to the logged-in admin
    @other_artisans = Artisan.where.not(admin: @admin) # Artisans belonging to other admins
  end

  def show; end

  def new
    @artisan = @admin.artisans.build
  end

  def create
    @artisan = @admin.artisans.build(artisan_params)

    if @artisan.save
      redirect_to dashboard_admin_path(@admin), notice: 'Artisan was successfully created.'
    else
      flash.now[:alert] = 'There was an error creating the artisan.'
      flash.now[:errors] = @artisan.errors.full_messages.join(', ')
      render :new
    end
  end

  def edit; end

  def update
    if @artisan.update(artisan_params)
      handle_post_update_actions
      redirect_to artisan_path(@artisan), notice: flash[:notice]
    else
      handle_update_failure
    end
  end

  def destroy
    store_name = @artisan.store_name
    if @artisan.destroy
      redirect_to dashboard_admin_path(@admin), notice: "#{store_name} and all associated data were successfully deleted."
    else
      redirect_to dashboard_admin_path(@admin), alert: "Failed to delete #{store_name}."
    end
  end

  def dashboard
    @products = @artisan.products
  end

  private

  def require_login
    return if current_user

    redirect_to auth_login_path, alert: 'You must be logged in to access this page.'
  end

  # Setter Methods
  def set_admin
    if params[:admin_id]
      @admin = Admin.find(params[:admin_id])
    elsif params[:id]
      @admin = Artisan.find(params[:id]).admin
    else
      raise ActiveRecord::RecordNotFound, 'Admin could not be determined'
    end
  end

  def set_artisan
    @artisan = Artisan.find(params[:id])
  end

  # Strong Parameters
  def artisan_params
    params.require(:artisan).permit(:store_name, :email, :password, :password_confirmation, :active)
  end

  # Utility Methods
  def handle_status_change
    messages = []
    if artisan_params[:active].present?
      messages << "Artisan has been successfully #{artisan_params[:active] == 'true' ? 'reactivated' : 'deactivated'}."
    end

    messages << 'Artisan details have been successfully updated.' if artisan_params.except(:active).to_h.any? { |_key, value| value.present? }

    flash[:notice] = messages.join(' ')
  end

  def handle_post_update_actions
    handle_status_change
    @artisan.save
    restore_artisan_session if current_user == @artisan
  end

  def restore_artisan_session
    session[:user_email] = @artisan.email
    session[:user_id] = @artisan.id
    session[:role] = 'artisan'
  end

  def handle_update_failure
    flash.now[:alert] = 'There was an error updating the artisan.'
    render :edit
  end
end
