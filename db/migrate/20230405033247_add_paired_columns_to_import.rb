class AddPairedColumnsToImport < ActiveRecord::Migration[7.0]
  def change
    add_column :imports, :columns_pair, :jsonb
  end
end
