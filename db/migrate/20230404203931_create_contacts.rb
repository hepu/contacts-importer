class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.integer :user_id
      t.integer :import_id
      t.string :name
      t.string :email
      t.datetime :birthdate
      t.string :phone
      t.string :address
      t.string :credit_card_number
      t.string :credit_card_network

      t.timestamps
    end
    add_index :contacts, :user_id
    add_index :contacts, :import_id
  end
end
