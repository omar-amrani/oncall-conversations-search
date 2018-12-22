class CreateConversationTags < ActiveRecord::Migration[5.1]
  def change
    create_table :conversation_tags do |t|
      t.integer :conversation_id
      t.integer :tag_id
    end
  end
end
