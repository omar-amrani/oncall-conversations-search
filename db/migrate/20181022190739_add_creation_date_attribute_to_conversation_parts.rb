class AddCreationDateAttributeToConversationParts < ActiveRecord::Migration[5.1]
  def change
      add_column :conversation_parts, :creation_date, :string

  end
end
