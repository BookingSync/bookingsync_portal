class CreateRemoteAccounts < ActiveRecord::Migration
  def change
    create_table :remote_accounts do |t|
      t.belongs_to :account, index: true
      t.integer :uid

      t.timestamps null: false
    end
  end
end
