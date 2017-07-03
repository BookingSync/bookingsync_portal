class CreatePhotos < ActiveRecord::Migration[4.2]
  def change
    create_table :photos do |t|
      t.belongs_to :rental, index: true
      t.integer :synced_id, index: true
      t.text :synced_data
      t.datetime :synced_all_at
      t.integer :position

      t.timestamps null: false
    end
  end
end
