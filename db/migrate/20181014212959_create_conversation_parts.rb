class CreateConversationParts < ActiveRecord::Migration[5.1]
  def change
    create_table :conversation_parts do |t|
      t.integer :conversation_part_id, :limit => 8
      t.text :conversation_part_body
      t.references :conversation, foreign_key: true
      t.timestamps
    end
  end

end
