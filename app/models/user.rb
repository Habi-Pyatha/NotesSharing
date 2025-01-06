# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string
#  phone                  :string
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true
  validates :phone, presence: true, format: { with: /\A\d{10}\z/, message: "Must be 10 digits" }

  has_many :notes
  has_one_attached :user_image
  validate :validate_user_image
  has_many :friendships
  has_many :friends, through: :friendship, source: :friend

  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  def send_friend_request(friend)
    friendships.create(friend: friend, status: "pending")
  end
  def accept_friend_request(friend)
    friendship = friendship.find_by(friend: friend)
    friendship.update(status: "accepted") if friendship
  end
  def reject_friend_request(friend)
    friendship = friendship.find_by(friend: friend)
    friendship.update(status: "rejected") if friendship
  end

  def friends
    (friends + inverse_friends).uniq
  end

  private
  def validate_user_image
    return unless user_image.attached?

    unless user_image.content_type.in?(%w[image/jpg image/png image/jpeg])
      errors.add(:user_image, " must be a PNG,JPG, or JPEG file")
    end

    if user_image.byte_size > 5.megabytes
      errors.add(:user_image, "is too large (must be less then 5 MB)")
    end
  end
end
