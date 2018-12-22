class AddSanitizedConversationPartBodyToConversationpart < ActiveRecord::Migration[5.1]
  def change
    add_column :conversation_parts, :sanitized_conversation_part_body, :text
  end
end
