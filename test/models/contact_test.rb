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
require "test_helper"

class ContactTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
