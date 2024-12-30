class ProductsController < ApplicationController
  before_action :set_artisan, only: %i[index show new create edit update destroy]

  def index
    @products = @artisan.products.all
  end

  def show
    @product = @artisan.products.find(params[:id])
  end

  def new
    @product = @artisan.products.build
  end

  def create
    @product = @artisan.products.build(product_params)
    if @product.save
      redirect_to artisan_path(@artisan), notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def edit
    @product = @artisan.products.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to artisan_product_path(@artisan, @product), notice: 'Product was successfully updated.'
    else
      flash.now[:alert] = 'There was an error updating the product.'
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to dashboard_artisan_path(@artisan), notice: 'Product was successfully deleted.'
  end

  private

  def set_artisan
    if params[:artisan_id]
      @artisan = Artisan.find(params[:artisan_id])
    elsif params[:id]
      @artisan = Artisan.find(params[:id]).admin
    else
      raise ActiveRecord::RecordNotFound, 'Artisan could not be determined'
    end
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :artisan_id)
  end
end
