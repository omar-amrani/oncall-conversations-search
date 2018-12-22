class AddCreationDateToConversationParts < ActiveRecord::Migration[5.1]
  def change
    add_column :conversation_parts, :creation_date, :integer, :limit => 8
  end
end
