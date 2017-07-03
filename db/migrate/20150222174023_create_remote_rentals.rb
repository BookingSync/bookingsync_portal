class CreateRemoteRentals < ActiveRecord::Migration[4.2]
  def change
    create_table :remote_rentals do |t|
      t.belongs_to :remote_account, index: true
      t.integer :uid
      t.text :remote_data
      t.datetime :synchronized_at

      t.timestamps null: false
    end
  end
end
