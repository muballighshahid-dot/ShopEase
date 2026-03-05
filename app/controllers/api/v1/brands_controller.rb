module Api
  module V1
    class PaymentsController < ApplicationController
      before_action :set_payment, only: [:show, :update, :destroy]

      def index
        render json: Payment.all, status: :ok
      end

      def show
        render json: @payment, status: :ok
      end

      def create
        payment = Payment.new(payment_params)

        if payment.save
          render json: payment, status: :created
        else
          render json: { errors: payment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @payment.update(payment_params)
          render json: @payment, status: :ok
        else
          render json: { errors: @payment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @payment.destroy
        render json: { message: "Payment deleted successfully" }, status: :ok
      end

      private

      def set_payment
        @payment = Payment.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Payment not found" }, status: :not_found
      end

      def payment_params
        params.require(:payment).permit(:order_id, :amount, :status, :payment_method)
      end
    end
  end
end