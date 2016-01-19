class AddSyncedSourceIdToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :synced_source_id, :integer
  end
end
