class CreateColumnPairings < ActiveRecord::Migration[7.0]
  def change
    create_table :column_pairings do |t|
      t.string :local_column
      t.string :csv_column
      t.integer :import_id

      t.timestamps
    end
    add_index :column_pairings, :local_column
    add_index :column_pairings, :import_id
  end
end
