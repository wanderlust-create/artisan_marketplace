module Api
  module V1
    class DiscountsController < ApplicationController
      def index
        product = Product.find(params[:product_id])
        discounts = product.discounts.order(:start_date)

        render json: discounts
      end
    end
  end
end
