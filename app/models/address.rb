class Address < ApplicationRecord
  belongs_to :user

  validates :street, :city, :state, :pincode, :country, presence: true
  validates :pincode, length: { is: 6 }
end