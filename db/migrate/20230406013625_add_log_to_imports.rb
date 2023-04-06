class AddLogToImports < ActiveRecord::Migration[7.0]
  def change
    add_column :imports, :log, :jsonb, default: {logs: []}
  end
end
