class Order < ApplicationRecord
  belongs_to :user
  has_one_attached :invoice_pdf

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_one :payment, dependent: :destroy
  has_one :shipment, dependent: :destroy

  enum :status, { pending: 0, confirmed: 1, shipped: 2, delivered: 3, cancelled: 4 }

  before_create :generate_order_number
  before_save :calculate_total_amount

  private

  def generate_order_number
    self.order_number = "ORD#{Time.now.to_i}#{rand(100)}"
  end

  def calculate_total_amount
    self.total_amount = order_items.sum { |item| item.quantity * item.price }
  end
end
