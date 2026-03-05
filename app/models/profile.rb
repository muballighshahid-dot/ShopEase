class Profile < ApplicationRecord
  belongs_to :user

  has_one_attached :profile_image

  validates :bio, presence: true, length: { minimum: 10 }

  before_save :format_gender

  private

  def format_gender
    self.gender = gender.capitalize if gender.present?
  end
end