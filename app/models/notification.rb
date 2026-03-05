class Notification < ApplicationRecord
  belongs_to :user

  scope :unread, -> { where(read: false) }

  before_create :set_default_read

  private

  def set_default_read
    self.read ||= false
  end
end