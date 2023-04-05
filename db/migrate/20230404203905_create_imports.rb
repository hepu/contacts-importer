class CreateImports < ActiveRecord::Migration[7.0]
  def change
    create_table :imports do |t|
      t.integer :user_id
      t.string :current_status

      t.timestamps
    end
    add_index :imports, :user_id
    add_index :imports, :current_status
  end
end
