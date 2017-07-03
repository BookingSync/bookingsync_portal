class CreateRentals < ActiveRecord::Migration[4.2]
  def change
    create_table :rentals do |t|
      t.belongs_to :account, index: true
      t.integer :synced_id, index: true
      t.text :synced_data
      t.datetime :synced_all_at
      t.integer :position
      t.datetime :published_at

      t.timestamps null: false
    end
  end
end
