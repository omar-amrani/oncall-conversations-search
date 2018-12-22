class Tag < ApplicationRecord
  has_many :conversation_tags
  has_many :conversations, through: :conversation_tags
  validates :tag_id, presence: true, uniqueness: { case_sensitive: false}
  validates :name, presence: true, uniqueness: { case_sensitive: false}
end
