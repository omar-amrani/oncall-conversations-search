class ConversationPart < ApplicationRecord
  belongs_to :conversation
  belongs_to :author
  validates :conversation_part_id, presence: true,
            uniqueness: { case_sensitive: false}
  validates :conversation_part_id, presence: true
  validates :author_id, presence: true
  searchkick highlight: [:sanitized_conversation_part_body]
end
