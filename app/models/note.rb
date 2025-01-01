# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  title      :string
#  content    :text
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Note < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  has_many_attached :note_images
  validate :validate_note_images


  private
  def validate_note_images
    return unless note_images.attached?
    note_images.each do |image|
      unless image.content_type.in?(%w[image/jpg image/png image/jpeg])
        errors.add(:image, " must be a PNG,JPG, or JPEG file")
      end

      if image.byte_size > 5.megabytes
        errors.add(:image, "is too large (must be less then 5 MB)")
      end
    end
  end
end
