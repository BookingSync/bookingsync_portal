class AddCanceledAtToConnections < ActiveRecord::Migration[5.0]
  def change
    add_column :connections, :canceled_at, :datetime
  end
end
