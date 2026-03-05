class CartsController < ApplicationController
  before_action :require_customer!
  before_action :set_cart, only: [:show, :edit, :update, :destroy]

  def index
    cart = current_user.cart || current_user.create_cart
    @carts = Cart.where(id: cart.id).includes(cart_items: :product)
  end

  def show
  end

  def new
    @cart = Cart.new
  end

  def create
    @cart = current_user.cart || current_user.build_cart(cart_params)

    if @cart.save
      redirect_to @cart, notice: "Cart created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @cart.update(cart_params)
      redirect_to @cart, notice: "Cart updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @cart.destroy
    redirect_to carts_path, notice: "Cart deleted successfully."
  end

  private

  def set_cart
    @cart = current_user.cart
    return if @cart && @cart.id.to_s == params[:id].to_s

    redirect_to carts_path, alert: "Cart not found."
  end

  def cart_params
    params.require(:cart).permit(:status)
  end
end
