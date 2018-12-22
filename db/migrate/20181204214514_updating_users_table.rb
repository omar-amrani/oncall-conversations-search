class UpdatingUsersTable < ActiveRecord::Migration[5.1]

  def up
    remove_column :users, :first_name
    remove_column :users, :last_name
    add_column :users, :name, :string
  end

  def down

  end
end
