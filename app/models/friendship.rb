# == Schema Information
#
# Table name: friendships
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  friend_id  :integer          not null
#  status     :string           default("pending")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"
  validates :status, inclusion: { in: [ "pending", "accepted", "rejected" ] }
  after_create_commit -> { broadcast_prepend_to "requests", partial: "friendships/pending_request", locals: { friendship: self }, target: "pending_request" }
  # after_update_commit -> { broadcast_replace_to "home", partial: "friendships/user", locals: { user: self }, target: "user_4" }

  after_create_commit -> { show_friend_request }
  scope :accepted, -> { where(status: "accepted") }

  def show_friend_request
  end
end
