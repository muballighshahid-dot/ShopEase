class WishlistItemsController < ApplicationController
  before_action :require_customer!
  before_action :set_wishlist_item, only: [:show, :edit, :update, :destroy]

  def index
    @wishlist_items = WishlistItem.joins(:wishlist).where(wishlists: { user_id: current_user.id })
  end

  def show
  end

  def new
    @wishlist_item = WishlistItem.new
  end

  def create
    wishlist = current_user.wishlists.find(wishlist_item_params[:wishlist_id])
    @wishlist_item = wishlist.wishlist_items.new(product_id: wishlist_item_params[:product_id])

    if @wishlist_item.save
      redirect_to @wishlist_item, notice: "Item added to wishlist."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @wishlist_item.update(wishlist_item_params)
      redirect_to @wishlist_item, notice: "Wishlist item updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @wishlist_item.destroy
    redirect_to wishlist_items_path, notice: "Item removed from wishlist."
  end

  private

  def set_wishlist_item
    @wishlist_item = WishlistItem.joins(:wishlist).where(wishlists: { user_id: current_user.id }).find(params[:id])
  end

  def wishlist_item_params
    params.require(:wishlist_item)
          .permit(:wishlist_id, :product_id)
  end
end
