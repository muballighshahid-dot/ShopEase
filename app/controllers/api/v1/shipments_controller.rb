module Api
  module V1
    class SuppliersController < ApplicationController
      before_action :set_supplier, only: [:show, :update, :destroy]

      def index
        render json: Supplier.all, status: :ok
      end

      def show
        render json: @supplier, status: :ok
      end

      def create
        supplier = Supplier.new(supplier_params)

        if supplier.save
          render json: supplier, status: :created
        else
          render json: { errors: supplier.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @supplier.update(supplier_params)
          render json: @supplier, status: :ok
        else
          render json: { errors: @supplier.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @supplier.destroy
        render json: { message: "Supplier deleted successfully" }, status: :ok
      end

      private

      def set_supplier
        @supplier = Supplier.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Supplier not found" }, status: :not_found
      end

      def supplier_params
        params.require(:supplier).permit(:name, :email, :phone, :address)
      end
    end
  end
end