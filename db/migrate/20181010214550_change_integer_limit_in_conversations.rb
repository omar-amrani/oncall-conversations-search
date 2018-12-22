class ChangeIntegerLimitInConversations < ActiveRecord::Migration[5.1]
  def change
    change_column :conversations, :conversation_id, :integer, :limit=> 8
  end
end
