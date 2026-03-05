class Brand < ApplicationRecord
  has_many :products

  has_one_attached :logo

  validates :name, presence: true, uniqueness: true

  before_save :capitalize_name

  private

  def capitalize_name
    self.name = name.titleize
  end
end