module Api
  module V1
    class BrandsController < ApplicationController
      before_action :set_brand, only: [:show, :update, :destroy]

      def index
        render json: Brand.all, status: :ok
      end

      def show
        render json: @brand, status: :ok
      end

      def create
        brand = Brand.new(brand_params)

        if brand.save
          render json: brand, status: :created
        else
          render json: { errors: brand.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @brand.update(brand_params)
          render json: @brand, status: :ok
        else
          render json: { errors: @brand.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @brand.destroy
        render json: { message: "Brand deleted successfully" }, status: :ok
      end

      private

      def set_brand
        @brand = Brand.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Brand not found" }, status: :not_found
      end

      def brand_params
        params.require(:brand).permit(:name, :description, :status)
      end
    end
  end
end