class ProductsController < ApplicationController
  before_action :set_product_and_authorize, only: %i[show edit update destroy]
  before_action :set_artisan, only: %i[index show]

  def index
    @products = @artisan.products.all
  end

  def show
    @active_discounts = @product.discounts.respond_to?(:current_and_upcoming_discounts) ? @product.discounts.current_and_upcoming_discounts : []
  end

  def new
    @product = @artisan.products.build
  end

  def create
    @product = @artisan.products.build(product_params)
    if @product.save
      redirect_to dashboard_artisan_path(@artisan), notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to artisan_product_path(@artisan, @product), notice: 'Product was successfully updated.'
    else
      flash.now[:alert] = 'There was an error updating the product.'
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to dashboard_artisan_path(@artisan), notice: 'Product was successfully deleted.'
  end

  private

  def set_artisan
    @artisan = find_artisan
  end

  def set_product_and_authorize
    @product = find_product
    return unless @product

    @artisan = find_artisan
    return unless @artisan

    # Check if the current artisan matches
    return if @artisan == @product.artisan

    flash[:alert] = 'You are not authorized to access this page'
    redirect_to dashboard_artisan_path(@artisan) and return
  end

  def find_product
    Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'The product you were looking for doesn\'t exist.'
    redirect_to params[:artisan_id] ? dashboard_artisan_path(params[:artisan_id]) : root_path and return
  end

  def find_artisan
    if params[:artisan_id]
      Artisan.find(params[:artisan_id])
    elsif params[:id]
      Product.find(params[:id]).artisan
    else
      raise ActiveRecord::RecordNotFound, 'Artisan could not be determined'
    end
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'The artisan you were looking for doesn\'t exist.'
    redirect_to dashboard_artisan_path(@artisan) and return
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :artisan_id)
  end
end
