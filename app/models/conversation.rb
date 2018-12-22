class Conversation < ApplicationRecord
has_many :conversation_parts
has_many :conversation_tags
has_many :tags, through: :conversation_tags
validates :conversation_id, presence: true,
          uniqueness: { case_sensitive: false }

end