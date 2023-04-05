class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :import
end

# == Schema Information
#
# Table name: contacts
#
#  id                  :bigint           not null, primary key
#  address             :string
#  birthdate           :datetime
#  credit_card_network :string
#  credit_card_number  :string
#  email               :string
#  name                :string
#  phone               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  import_id           :integer
#  user_id             :integer
#
# Indexes
#
#  index_contacts_on_import_id  (import_id)
#  index_contacts_on_user_id    (user_id)
#
