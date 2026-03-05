class WishlistsController < ApplicationController
  before_action :require_customer!
  before_action :set_wishlist, only: [:show, :edit, :update, :destroy]

  def index
    @wishlists = current_user ? current_user.wishlists.includes(:wishlist_items).order(updated_at: :desc) : Wishlist.none
  end

  def show
  end

  def new
    @wishlist = Wishlist.new
  end

  def create
    @wishlist = current_user.wishlists.new(wishlist_params)

    if @wishlist.save
      redirect_to @wishlist, notice: "Wishlist created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @wishlist.update(wishlist_params)
      redirect_to @wishlist, notice: "Wishlist updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @wishlist.destroy
    redirect_to wishlists_path, notice: "Wishlist deleted successfully."
  end

  private

  def set_wishlist
    @wishlist = current_user.wishlists.find(params[:id])
  end

  def wishlist_params
    params.require(:wishlist).permit(:name)
  end
end
