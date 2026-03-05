module Api
  module V1
    class NotificationsController < ApplicationController
      before_action :set_notification, only: [:show, :destroy]

      def index
        render json: Notification.all, status: :ok
      end

      def show
        render json: @notification, status: :ok
      end

      def destroy
        @notification.destroy
        render json: { message: "Notification deleted successfully" }, status: :ok
      end

      private

      def set_notification
        @notification = Notification.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Notification not found" }, status: :not_found
      end
    end
  end
end