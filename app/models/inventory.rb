class Inventory < ApplicationRecord
  belongs_to :product

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  after_update :check_low_stock

  private

  def check_low_stock
    if quantity < 5
      product.user.notifications.create(
        title: "Low Stock Alert",
        message: "Your product stock is below 5.",
        read: false
      )
    end
  end
end