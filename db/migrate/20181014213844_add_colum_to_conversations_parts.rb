class AddColumToConversationsParts < ActiveRecord::Migration[5.1]
  def change
    add_column :conversation_parts, :author_type, :string
  end
end
