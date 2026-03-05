class Coupon < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :discount_value, numericality: { greater_than: 0 }

  before_save :upcase_code

  def active?
    active && expiry_date >= Date.today
  end

  private

  def upcase_code
    self.code = code.upcase
  end
end