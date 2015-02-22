class CreateRentals < ActiveRecord::Migration
  def change
    create_table :rentals do |t|
      t.belongs_to :account, index: true
      t.integer :synced_id, index: true
      t.text :synced_data
      t.datetime :synced_all_at
      t.integer :position
      t.datetime :published_at

      t.timestamps
    end
  end
end
