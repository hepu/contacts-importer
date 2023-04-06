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