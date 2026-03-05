class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :add_to_cart, :add_to_wishlist, :quick_order]
  before_action :require_admin!, only: [:new, :create, :edit, :update, :destroy]
  before_action :require_customer!, only: [:add_to_cart, :add_to_wishlist, :quick_order]

  def index
    @products = Product.includes(:category, images_attachments: :blob).order(created_at: :desc)
  end

  def show
    @reviews = @product.reviews.includes(:user).order(created_at: :desc)
    @review = @product.reviews.new
  end

  def new
    @product = Product.new
  end

  def create
    @product = current_user.products.build(product_params)

    if @product.save
      NotificationMailer.product_created(@product).deliver_later
      redirect_to @product, notice: "Product created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      NotificationMailer.product_updated(@product).deliver_later
      redirect_to @product
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path
  end

  def add_to_cart
    cart = current_user.cart || current_user.create_cart
    cart_item = cart.cart_items.find_by(product: @product)

    if cart_item
      cart_item.update(quantity: cart_item.quantity + 1)
    else
      cart.cart_items.create(product: @product, quantity: 1)
    end

    redirect_back fallback_location: products_path, notice: "#{@product.name} added to cart."
  end

  def add_to_wishlist
    wishlist = current_user.wishlists.first_or_create(name: "My Wishlist")
    wishlist.wishlist_items.find_or_create_by(product: @product)

    redirect_back fallback_location: products_path, notice: "#{@product.name} added to wishlist."
  end

  def quick_order
    if @product.stock.to_i <= 0
      redirect_back fallback_location: root_path, alert: "#{@product.name} is out of stock."
      return
    end

    order = current_user.orders.create!(status: :pending)
    order.order_items.create!(product: @product, quantity: 1)

    redirect_to orders_path, notice: "Order placed for #{@product.name}."
  rescue ActiveRecord::RecordInvalid => e
    redirect_back fallback_location: root_path, alert: "Could not place order: #{e.message}"
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product)
          .permit(:name, :description, :price, :stock, :status, :category_id, images: [])
  end
end
