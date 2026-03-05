class CartItemsController < ApplicationController
  before_action :require_customer!
  before_action :set_cart_item, only: [:show, :edit, :update, :destroy]

  def index
    @cart_items = current_user.cart&.cart_items&.includes(:product) || CartItem.none
  end

  def show
  end

  def new
    @cart_item = CartItem.new
  end

  def edit
  end

  def create
    product_id = params[:product_id] || params.dig(:cart_item, :product_id)
    product = Product.find(product_id)
    cart = current_user.cart || current_user.create_cart
    cart_item = cart.cart_items.find_by(product: product)

    if cart_item
      cart_item.update(quantity: cart_item.quantity + 1)
    else
      cart.cart_items.create(product: product, quantity: 1)
    end

    redirect_to carts_path, notice: "#{product.name} added to cart."
  end

  def update
    if @cart_item.update(cart_item_params)
      redirect_to carts_path, notice: "Cart item updated."
    else
      redirect_to carts_path, alert: @cart_item.errors.full_messages.to_sentence
    end
  end

  def destroy
    @cart_item.destroy
    redirect_to carts_path, notice: "Item removed from cart."
  end

  private

  def set_cart_item
    @cart_item = CartItem.joins(:cart).where(carts: { user_id: current_user.id }).find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
