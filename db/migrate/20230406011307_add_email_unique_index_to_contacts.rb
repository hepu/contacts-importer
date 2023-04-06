class AddEmailUniqueIndexToContacts < ActiveRecord::Migration[7.0]
  def change
    add_index :contacts, [:email, :user_id], unique: true
  end
end
