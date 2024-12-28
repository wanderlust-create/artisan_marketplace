class ProductsController < ApplicationController
  before_action :set_artisan, only: %i[new create show]

  def index
    @products = Product.all
  end

  def show; end

  def new
    @product = @artisan.products.new
  end

  def create
    @product = @artisan.products.new(product_params)
    if @product.save
      redirect_to artisan_path(@artisan), notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  # # PATCH/PUT /products/1 or /products/1.json
  # def update
  #   respond_to do |format|
  #     if @product.update(product_params)
  #       format.html { redirect_to @product, notice: 'Product was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @product }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #       format.json { render json: @product.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /products/1 or /products/1.json
  # def destroy
  #   @product.destroy

  #   respond_to do |format|
  #     format.html { redirect_to products_path, status: :see_other, notice: 'Product was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private

  def set_artisan
    if params[:artisan_id]
      # When `artisan_id` is explicitly provided (e.g., during creation)
      @artisan = Artisan.find(params[:artisan_id])
    elsif params[:id]
      # When showing or editing a product, use the foreign key on the artisan
      @artisan = Artisan.find(params[:id]).admin
    else
      raise ActiveRecord::RecordNotFound, 'Artisan could not be determined'
    end
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :artisan_id)
  end
end
