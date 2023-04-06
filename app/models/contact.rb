class Contact < ApplicationRecord
  PHONE_REGEXP = /\A\(\+\d{1}|\d{2}\)\s\d{3}(\S|\s)\d{3}(\S|\s)\d{2}(\S|\s)\d{2}((\S|\s)\d{2})?\z/
  NAME_REGEXP = /\A([a-zA-Z0-9]+(\s|\-)*)*\z/
  BIRTHDATE_REGEXP = /\A\d{4}\/\d{2}\/\d{2}\z|\A\d{4}\-\d{2}\-\d{2}\z/

  belongs_to :user
  belongs_to :import
  
  encrypts :credit_card_number
  
  validates :credit_card_number, presence: true, length: { minimum: 12, maximum: 16 }
  validates :credit_card_network, presence: true
  validates :last_4, presence: true, length: { is: 4 }
  validates :birthdate, presence: true, format: { with: BIRTHDATE_REGEXP }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address, presence: true
  validates :phone, format: { with: PHONE_REGEXP }
  validates :name, presence: true, format: { with: NAME_REGEXP }
  
  paginates_per 50
end

# == Schema Information
#
# Table name: contacts
#
#  id                  :bigint           not null, primary key
#  address             :string
#  birthdate           :string
#  credit_card_network :string
#  credit_card_number  :string
#  email               :string
#  last_4              :string
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
