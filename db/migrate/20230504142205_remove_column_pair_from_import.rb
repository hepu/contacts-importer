class RemoveColumnPairFromImport < ActiveRecord::Migration[7.0]
  def change
    remove_column :imports, :columns_pair, :jsonb
  end
end
