class CreateAuthorTable < ActiveRecord::Migration[5.1]
  def change
    create_table :author do |t|
      t.string :type
      t.string :author_id
      t.string :name
      t.string :image_url
    end
  end
end
