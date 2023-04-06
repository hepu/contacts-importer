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