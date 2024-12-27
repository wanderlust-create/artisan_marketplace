class ArtisansController < ApplicationController
  before_action :set_admin, only: %i[new create show edit update destroy] # rubocop:disable Rails/LexicallyScopedActionFilter

  def new
    @artisan = @admin.artisans.new
  end

  def create
    @artisan = @admin.artisans.new(artisan_params)

    if @artisan.save
      redirect_to admin_path(@admin), notice: 'Artisan was successfully created.'
    else
      render :new
    end
  end

  def index
    @artisans = @admin.artisans
  end

  def edit
    @artisan = @admin.artisans.find(params[:id])
  end

  def update
    @artisan = @admin.artisans.find(params[:id])
    if @artisan.update(artisan_params)
      redirect_to admin_path(@admin), notice: 'Artisan was successfully updated.'
    else
      flash.now[:alert] = 'There was an error updating the artisan.'
      render :edit
    end
  end

  def destroy
    @artisan = @admin.artisans.find(params[:id])
    @artisan.destroy
    redirect_to admin_path(@admin), notice: 'Artisan was successfully deleted.'
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

  def artisan_params
    params.require(:artisan).permit(:store_name, :email, :password, :password_confirmation)
  end
end
