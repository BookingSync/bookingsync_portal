class CreateRates < ActiveRecord::Migration[4.2]
  def change
    create_table :rates do |t|
      t.belongs_to :rental, index: true
      t.integer :synced_id, index: true
      t.text :synced_data
      t.datetime :synced_all_at

      t.timestamps null: false
    end
  end
end
