module Api
  module V1
    class CouponsController < ApplicationController
      before_action :set_coupon, only: [:show, :update, :destroy]

      def index
        render json: Coupon.all, status: :ok
      end

      def show
        render json: @coupon, status: :ok
      end

      def create
        coupon = Coupon.new(coupon_params)

        if coupon.save
          render json: coupon, status: :created
        else
          render json: { errors: coupon.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @coupon.update(coupon_params)
          render json: @coupon, status: :ok
        else
          render json: { errors: @coupon.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @coupon.destroy
        render json: { message: "Coupon deleted successfully" }, status: :ok
      end

      private

      def set_coupon
        @coupon = Coupon.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Coupon not found" }, status: :not_found
      end

      def coupon_params
        params.require(:coupon).permit(:code, :discount_percentage, :expires_at)
      end
    end
  end
end