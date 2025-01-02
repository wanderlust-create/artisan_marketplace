class ArtisansController < ApplicationController
  before_action :set_admin, only: %i[index show new create edit update destroy]
  before_action :set_artisan, only: %i[show update]

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
    @artisan = @admin.artisans.find(params[:id])
  end

  def update
    if @artisan.update(artisan_params)
      handle_status_change
      redirect_to artisan_path(@artisan), notice: flash[:notice]
    else
      flash.now[:alert] = 'There was an error updating the artisan.'
      render :edit
    end
  end

  def destroy
    @artisan = @admin.artisans.find(params[:id])
    store_name = @artisan.store_name # Fetch the store name before deletion
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

  private

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

  def set_artisan
    @artisan = Artisan.find(params[:id])
  end

  def artisan_params
    params.require(:artisan).permit(:store_name, :email, :password, :password_confirmation, :active)
  end

  def handle_status_change
    flash[:notice] = if artisan_params[:active] == 'false'
                       'Artisan has been successfully deactivated.'
                     elsif artisan_params[:active] == 'true'
                       'Artisan has been successfully reactivated.'
                     else
                       'Artisan details have been successfully updated.'
                     end
  end
end
