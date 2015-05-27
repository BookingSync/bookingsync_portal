class CreateAvailabilities < ActiveRecord::Migration
  def change
    create_table :availabilities do |t|
      t.belongs_to :rental, index: true
      t.integer :synced_id, index: true
      t.datetime :synced_all_at
      t.string :map
      t.date :start_date

      t.timestamps null: false
    end
  end
end
