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
end
