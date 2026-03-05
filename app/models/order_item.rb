class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }

  before_create :set_price
  after_create :reduce_product_stock

  private

  def set_price
    self.price = product.price
  end

  def reduce_product_stock
    product.update(stock: product.stock - quantity)
  end
end