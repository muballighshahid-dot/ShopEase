module Api
  module V1
    class MessagesController < ApplicationController
      before_action :set_message, only: [:show, :destroy]

      def index
        render json: Message.all, status: :ok
      end

      def show
        render json: @message, status: :ok
      end

      def create
        message = Message.new(message_params)

        if message.save
          render json: message, status: :created
        else
          render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @message.destroy
        render json: { message: "Message deleted successfully" }, status: :ok
      end

      private

      def set_message
        @message = Message.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Message not found" }, status: :not_found
      end

      def message_params
        params.require(:message).permit(:sender_id, :receiver_id, :content)
      end
    end
  end
end