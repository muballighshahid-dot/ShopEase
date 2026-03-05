module Api
  module V1
    class ProductsController < ApplicationController
      before_action :set_product, only: [:show, :update, :destroy]

      def index
        render json: Product.all, status: :ok
      end

      def show
        render json: @product, status: :ok
      end

      def create
        product = Product.new(product_params)

        if product.save
          NotificationMailer.product_created(product).deliver_later
          render json: product, status: :created
        else
          render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @product.update(product_params)
          NotificationMailer.product_updated(@product).deliver_later
          render json: @product, status: :ok
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @product.destroy
        render json: { message: "Product deleted successfully" }, status: :ok
      end

      private

      def set_product
        @product = Product.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Product not found" }, status: :not_found
      end

      def product_params
        params.require(:product).permit(:name, :description, :price, :stock, :category_id, :user_id)
      end
    end
  end
end
