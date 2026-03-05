class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :rating, inclusion: { in: 1..5 }

  after_create :notify_seller

  private

  def notify_seller
    product.user.notifications.create(
      title: "New Review",
      message: "Your product received a new review.",
      read: false
    )
  end
end