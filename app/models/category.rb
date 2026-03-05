class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  before_save :capitalize_name

  validates :name, presence: true, uniqueness: true

  private

  def capitalize_name
    self.name = name.titleize
  end
end