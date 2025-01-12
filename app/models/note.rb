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
#  access     :string           default("public")
#
class Note < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  has_many_attached :note_images
  validate :validate_note_images
  validates :access, inclusion: { in: %w[public friend onlyme] }
  after_create_commit -> { broadcast_prepend_to "notes", partial: "shared/note", locals: { note: self }, target: "notes_list" }
  after_update_commit -> { broadcast_update_to "notes", partial: "shared/note", locals: { note: self  } }
  after_destroy_commit -> { broadcast_remove_to "notes" }

  def self.search_by_title(query)
    query = Array(query).first.to_s.downcase
    joins(:user)
      .where("LOWER(notes.title) LIKE :query OR LOWER(notes.content) LIKE :query OR LOWER(users.username) LIKE :query", query: "%#{query}%")
  end


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
