# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Clear old data
Order.destroy_all
User.destroy_all
Product.destroy_all
Category.destroy_all


# Users
customer = User.create!(
  name: "John Doe",
  email: "john@example.com",
  phone: "9876543210",
  password: "password",
  role: "customer"
)

admin = User.create!(
  name: "Admin",
  email: "admin@example.com",
  phone: "9999999999",
  password: "password",
  role: "admin"
)

# Categories
electronics = Category.create!(name: "Electronics")
clothing = Category.create!(name: "Clothing")

# Products
phone = Product.create!(
  name: "iPhone 15",
  price: 900,
  stock: 50,
  user: admin,
  category: electronics
)

shirt = Product.create!(
  name: "T Shirt",
  price: 25,
  stock: 100,
  user: admin,
  category: clothing
)

# Orders
order = Order.create!(user: customer)

# Order Items
OrderItem.create!(order: order, product: phone, quantity: 1)
OrderItem.create!(order: order, product: shirt, quantity: 2)