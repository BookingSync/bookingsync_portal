class CreateRemoteAccounts < ActiveRecord::Migration[4.2]
  def change
    create_table :remote_accounts do |t|
      t.belongs_to :account, index: true
      t.integer :uid

      t.timestamps null: false
    end
  end
end
