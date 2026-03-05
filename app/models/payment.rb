class Payment < ApplicationRecord
  belongs_to :order

  before_create :set_default_status

  private

  def set_default_status
    self.status ||= "pending"
  end
end