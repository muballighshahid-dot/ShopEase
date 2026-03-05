module Api
  module V1
    class OrdersController < ApplicationController
      before_action :set_order, only: [:show, :update, :destroy]

      def index
        render json: Order.all, status: :ok
      end

      def show
        render json: @order, status: :ok
      end

      def create
        order = Order.new(order_params)

        if order.save
          render json: order, status: :created
        else
          render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @order.update(order_params)
          NotificationMailer.order_status_changed(@order).deliver_later if @order.saved_change_to_status?
          render json: @order, status: :ok
        else
          render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @order.destroy
        render json: { message: "Order deleted successfully" }, status: :ok
      end

      private

      def set_order
        @order = Order.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Order not found" }, status: :not_found
      end

      def order_params
        params.require(:order).permit(:user_id, :status)
      end
    end
  end
end
