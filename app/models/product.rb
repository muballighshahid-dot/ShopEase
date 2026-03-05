class Product < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many_attached :images

  has_many :order_items, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one :inventory, dependent: :destroy

  has_many :orders, through: :order_items

  validates :name, :price, :stock, presence: true
  validate :stock_cannot_be_negative

  after_create :create_inventory

  private

  def create_inventory
    Inventory.create(product: self, quantity: stock)
  end

  def stock_cannot_be_negative
    errors.add(:stock, "cannot be negative") if stock.present? && stock < 0
  end
end
