class ChangeConversationPartsTableToUtf8mb4 < ActiveRecord::Migration[5.1]
  def up
    execute "ALTER TABLE conversation_parts CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE conversation_parts MODIFY conversation_part_body TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE conversation_parts MODIFY sanitized_conversation_part_body TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE conversation_parts MODIFY author_id VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
  end
  def down
    execute "ALTER TABLE conversation_parts CONVERT TO CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE conversation_parts MODIFY conversation_part_body TEXT CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE conversation_parts MODIFY sanitized_conversation_part_body TEXT CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE conversation_parts MODIFY author_id VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin"
  end
end
