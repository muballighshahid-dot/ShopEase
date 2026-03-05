class User < ApplicationRecord
  has_secure_password    #Authentication

  has_one_attached :avatar   #Active Storage
  #means each user have only one avatar

  #Associations 
  has_one :profile, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :wishlists, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :messages, dependent: :destroy

  #enum
  enum :role, { customer: 0, admin: 1, seller: 2 }, prefix: true, default: :customer
  enum :notification_preference, { all: 0, important_only: 1 }, prefix: true


  #Validations 
  validates :name, :email, :phone, presence: true
  validates :email, uniqueness: true

  #Callbacks
  after_create :create_cart
  after_create :send_welcome_notification

  
  private

  def create_cart
    Cart.create(user: self)
  end

  def send_welcome_notification
    notifications.create(title: "Welcome", message: "Welcome to our platform!", read: false)
  end
end
