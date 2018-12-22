class DeleteAuthorTypeFromConversationPart < ActiveRecord::Migration[5.1]
  def change
    remove_column :conversation_parts, :author_type
  end
end
