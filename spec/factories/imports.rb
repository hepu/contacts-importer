# == Schema Information
#
# Table name: imports
#
#  id             :bigint           not null, primary key
#  current_status :string
#  log            :jsonb
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#
# Indexes
#
#  index_imports_on_current_status  (current_status)
#  index_imports_on_user_id         (user_id)
#
FactoryBot.define do
  factory :import do
    columns_pair do
      {
        address: 'address',
        birthdate: 'birthdate',
        credit_card_number: 'credit_card_number',
        email: 'email',
        name: 'name',
        phone: 'phone'
      }
    end
    log { { logs: [] } }
    user
  end
end
