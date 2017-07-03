class CreateConnections < ActiveRecord::Migration[4.2]
  def change
    create_table :connections do |t|
      t.belongs_to :remote_rental, index: true
      t.belongs_to :rental, index: true

      t.timestamps null: false
    end
  end
end
