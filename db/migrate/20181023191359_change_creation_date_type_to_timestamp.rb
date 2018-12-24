class ChangeCreationDateTypeToTimestamp < ActiveRecord::Migration[5.1]
  def up
    change_column :conversation_parts, :creation_date, :Time
  end
  def down
    change_column :conversation_parts, :creation_date, :string
  end
end

