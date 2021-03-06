class CreateAccounts < ActiveRecord::Migration[4.2]
  def change
    create_table :accounts do |t|
      t.string :provider
      t.integer :synced_id, index: true
      t.string :name
      t.string :oauth_access_token
      t.string :oauth_refresh_token
      t.datetime :oauth_expires_at
      t.text :synced_data
      t.datetime :synced_all_at
      t.string :email

      t.timestamps null: false
    end
  end
end
