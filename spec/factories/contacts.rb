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
#  index_contacts_on_email_and_user_id  (email,user_id) UNIQUE
#  index_contacts_on_import_id          (import_id)
#  index_contacts_on_user_id            (user_id)
#
FactoryBot.define do
  factory :contact do
    address { FFaker::Address.street_address }
    birthdate { '2020/01/01' }
    credit_card_number { '5555555555554444' }
    credit_card_network { 'master' }
    email { FFaker::Internet.email }
    last_4 { '4444' }
    name { FFaker::Name.html_safe_name }
    phone { "(#{FFaker::PhoneNumber.phone_calling_code}) 111 111 11 11" }
    import
    user
  end
end
