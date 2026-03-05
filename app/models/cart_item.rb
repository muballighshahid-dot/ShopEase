class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }

  after_save :update_cart_total

  private

  def update_cart_total
    cart.save
  end
end