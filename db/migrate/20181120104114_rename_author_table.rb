class RenameAuthorTable < ActiveRecord::Migration[5.1]
  def self.up
    rename_table :author, :authors
  end

  def self.down
    rename_table :authors, :author
  end
end
