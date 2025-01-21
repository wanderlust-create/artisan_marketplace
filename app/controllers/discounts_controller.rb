class DiscountsController < ApplicationController
  before_action :set_product
  before_action :set_discount, only: %i[edit update destroy]

  # Public Actions
  def new
    @discount = @product.discounts.new
  end

  def create
    @discount = @product.discounts.new(adjusted_discount_params)

    if @discount.save
      redirect_to artisan_product_path(@product.artisan, @product), notice: 'Discount was successfully created.'
    else
      handle_failed_discount_creation
    end
  end

  def edit; end

  def update
    if @discount.update(discount_params)
      redirect_to artisan_product_path(@product.artisan, @product), notice: 'Discount was successfully updated.'
    else
      flash.now[:alert] = 'Failed to update discount. Please check the form for errors.'
      render :edit
    end
  end

  def destroy
    @discount.destroy
    redirect_to artisan_product_path(@product.artisan, @product), notice: 'Discount was successfully deleted.'
  end

  private

  # Callbacks
  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_discount
    @discount = @product.discounts.find(params[:id])
  end

  # Parameter Helpers
  def discount_params
    params.require(:discount).permit(:discount_price, :percentage, :start_date, :end_date, :discount_type)
  end

  def adjusted_discount_params
    {
      discount_price: calculate_discount_price,
      start_date: params[:discount][:start_date],
      end_date: params[:discount][:end_date]
    }
  end

  # Calculation Helpers
  def calculate_discount_price
    if params[:discount][:discount_type] == 'Discount Price'
      params[:discount][:discount_value].to_f
    elsif params[:discount][:discount_type] == 'Percentage Reduction'
      percentage = params[:discount][:discount_value].to_f
      calculate_rounded_discount_price(percentage, @product.price)
    end
  end

  def calculate_rounded_discount_price(percentage, original_price)
    (original_price * ((100 - percentage) / 100.0)).round(2)
  end

  # Error Handling
  def handle_failed_discount_creation
    flash.now[:alert] = 'Failed to create discount. Please check the form for errors.'
    flash.now[:errors] = @discount.errors.full_messages.join(', ')
    Rails.logger.debug("Flash contents: #{flash.inspect}")
    render :new, status: :unprocessable_entity
  end
end
