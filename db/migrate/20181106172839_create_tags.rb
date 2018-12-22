class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.integer :tag_id, :limit=> 8
      t.string :name

    end
  end
end
