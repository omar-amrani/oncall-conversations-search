class DeleteCreationDateFromConversationParts < ActiveRecord::Migration[5.1]
  def change
    remove_column :conversation_parts, :creation_date
  end
end
