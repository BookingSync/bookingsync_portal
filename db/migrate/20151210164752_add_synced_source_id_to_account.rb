class AddSyncedSourceIdToAccount < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :synced_source_id, :integer
  end
end
