class DiscountsController < ApplicationController
  before_action :set_product
  before_action :set_discount, only: %i[edit update destroy]

  def new
    @discount = @product.discounts.build
  end

  def create
    @discount = @product.discounts.build(adjusted_discount_params)

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

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_discount
    @discount = @product.discounts.find(params[:id])
  end

  def discount_params
    params.require(:discount).permit(:discount_price, :percentage_off, :start_date, :end_date, :original_price, :discount_type)
  end

  def adjusted_discount_params
    {
      discount_price: calculate_discount_price,
      percentage_off: extract_percentage_off,
      discount_type: normalized_discount_type,
      original_price: @product.price,
      start_date: params[:discount][:start_date],
      end_date: params[:discount][:end_date]
    }
  end

  # rubocop:disable Style/EmptyElse
  # Explicitly returning nil for clarity when discount_type is invalid or missing
  def normalized_discount_type
    case params[:discount][:discount_type]
    when 'Discount Price' then 'price'
    when 'Percentage Reduction' then 'percentage'
    else nil
    end
  end
  # rubocop:enable Style/EmptyElse

  def extract_percentage_off
    return unless normalized_discount_type == 'percentage'

    params[:discount][:discount_value].to_f
  end

  def calculate_discount_price
    value = params[:discount][:discount_value].to_f

    case normalized_discount_type
    when 'price' then value
    when 'percentage' then calculate_rounded_discount_price(value, @product.price)
    end
  end

  def calculate_rounded_discount_price(percentage, original_price)
    (original_price * ((100 - percentage) / 100.0)).round(2)
  end

  def handle_failed_discount_creation
    flash.now[:alert] = 'Failed to create discount. Please check the form for errors.'
    flash.now[:errors] = @discount.errors.full_messages.join(', ')
    render :new, status: :unprocessable_entity
  end
end
