class HomeController < ApplicationController
  def index
    @featured_products = Product.includes(:category, images_attachments: :blob)
                                .order(Arel.sql("RANDOM()"))
                                .limit(36)
    @user_orders_count = current_user&.orders&.count.to_i
    @user_wishlists_count = current_user&.wishlists&.count.to_i
    @user_cart_items_count = current_user&.cart&.cart_items&.sum(:quantity).to_i
  end
end
