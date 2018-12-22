class CreateAdmins < ActiveRecord::Migration[5.1]
  def change
    create_table :admins do |t|
      t.integer :admin_id, :limit=> 8
      t.string :name
      t.string :image_url
    end
  end
end
