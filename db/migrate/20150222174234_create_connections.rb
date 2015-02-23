class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.belongs_to :remote_rental, index: true
      t.belongs_to :rental, index: true
      t.timestamps
    end
  end
end
