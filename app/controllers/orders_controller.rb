class OrdersController < ApplicationController
  before_action :require_customer!
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = current_user.orders.includes(order_items: :product).order(created_at: :desc)
  end

  def show
  end

  def new
    @order = Order.new
  end

  def create
    @order = current_user.orders.build(order_params)

    if @order.save
      redirect_to @order
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @order.update(order_params)
      NotificationMailer.order_status_changed(@order).deliver_later if @order.saved_change_to_status?
      redirect_to @order
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_path
  end

  def place_from_cart
    cart = current_user.cart
    cart_items = cart&.cart_items&.includes(:product).to_a

    if cart_items.blank?
      redirect_to carts_path, alert: "Your cart is empty."
      return
    end

    Order.transaction do
      @order = current_user.orders.create!(status: :pending)

      cart_items.each do |item|
        @order.order_items.create!(product: item.product, quantity: item.quantity)
      end

      cart.cart_items.destroy_all
      cart.save!
    end

    redirect_to orders_path, notice: "Order placed successfully."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to carts_path, alert: "Could not place order: #{e.message}"
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
