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
require 'rails_helper'

RSpec.describe Contact, type: :model do
  subject(:contact) { build(:contact) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      is_expected.to be_valid
    end
    
    describe '#address' do
      describe 'when its not present' do
        before { contact.address = nil }
        
        it { is_expected.not_to be_valid }
      end
    end
    
    describe '#birthdate' do
      describe 'when format its not %Y/%m/%d' do
        before { contact.birthdate = 'Jan/01/2020' }
        
        it { is_expected.not_to be_valid }
      end

      describe 'when format its not %Y-%m-%d' do
        before { contact.birthdate = 'Jan-01-2020' }
        
        it { is_expected.not_to be_valid }
      end
    end
    
    describe '#credit_card_number' do
      describe 'when its not present' do
        before { contact.credit_card_number = nil }
        
        it { is_expected.not_to be_valid }
      end

      describe 'when length is incorrect' do
        before { contact.credit_card_number = '123456' }
        
        it { is_expected.not_to be_valid }
      end
    end
    
    describe '#credit_card_network' do
      describe 'when its not present' do
        before { contact.credit_card_network = nil }
        
        it { is_expected.not_to be_valid }
      end
    end
    
    describe '#email' do
      describe 'when its not present' do
        before { contact.email = nil }
        
        it { is_expected.not_to be_valid }
      end

      describe 'when the format is not correct' do
        before { contact.email = 'some+weird/@email,com' }
        
        it { is_expected.not_to be_valid }
      end
    end
    
    describe '#last_4' do
      describe 'when its not present' do
        before { contact.last_4 = nil }
        
        it { is_expected.not_to be_valid }
      end

      describe 'when the length is not correct' do
        before { contact.last_4 = '123' }
        
        it { is_expected.not_to be_valid }
      end
    end
    
    describe '#name' do
      describe 'when its not present' do
        before { contact.name = nil }
        
        it { is_expected.not_to be_valid }
      end

      describe 'when the format is not correct' do
        before { contact.name = '@dditional *chars+' }
        
        it { is_expected.not_to be_valid }
      end
    end
    
    describe '#phone' do
      describe 'when the format is not correct' do
        before { contact.phone = '300200' }
        
        it { is_expected.not_to be_valid }
      end
    end
  end
end
