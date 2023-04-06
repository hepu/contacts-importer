class AddLast4ToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :last_4, :string
  end
end
