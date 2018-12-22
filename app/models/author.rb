class Author < ApplicationRecord
has_many :conversation_parts
validates :author_id, presence: true,
          uniqueness: { case_sensitive: false }
end