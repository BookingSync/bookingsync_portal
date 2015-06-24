class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :provider
      t.integer :uid, index: true
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
