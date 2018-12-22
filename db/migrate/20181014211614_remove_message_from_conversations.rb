class RemoveMessageFromConversations < ActiveRecord::Migration[5.1]
  def change
    remove_column :conversations, :message
  end
end
