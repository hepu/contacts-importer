require 'rails_helper'

RSpec.describe ImportContactsService, type: :service do
  subject(:service) { described_class.new(import) }
  
  let(:file_happy_path) { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/example_happy_path.csv") }
  let(:file_wrong_fields) { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/example_wrong_fields.csv") }
  let(:file) { file_happy_path }
  let(:user) { create(:user) }
  let(:import) { create(:import, user: user, file: file) }
  
  describe '#call' do
    describe 'when the import file is not present' do
      before do
        import.file = nil
        import.save!
      end
      
      it 'raises an error' do
        expect { service.call }.to raise_error(StandardError)
      end
    end

    describe 'when the import file is present' do
      describe 'when file has no errors' do
        describe 'when all contacts were imported successfully' do
          it 'creates all Contacts' do
            expect { service.call }.to change { Contact.count }.by(2)
          end
          
          it 'marks Import as finished' do
            service.call
            expect(import.reload.finished?).to be_truthy
          end
        end

        describe 'when some contacts are repeated' do
          let!(:repeated_contacts) do
            create(:contact, email: 'one@test.com', user_id: import.user_id)
          end
          
          it 'marks the contact with error in the logs' do
            service.call
            expect(import.log['logs'].select {|log| log['error'] }.count).to eq(1)
          end
          
          it 'marks Import as finished' do
            service.call
            expect(import.reload.finished?).to be_truthy
          end
          
          it 'creates Contacts without errors' do
            expect { service.call }.to change { Contact.count }.by(1)
          end
        end

        describe 'when all contacts are repeated' do
          let!(:repeated_contacts) do
            create(:contact, email: 'one@test.com', user_id: import.user_id)
            create(:contact, email: 'two@test.com', user_id: import.user_id)
          end
          
          it 'marks the contacts with errors in the logs' do
            service.call
            expect(import.log['logs'].select {|log| log['error'] }.count).to eq(2)
          end
          
          it 'marks Import as failed' do
            service.call
            expect(import.reload.failed?).to be_truthy
          end
          
          it 'creates no Contacts' do
            expect { service.call }.to change { Contact.count }.by(0)
          end
        end
      end

      describe 'when file has errors' do
        let(:file) { file_wrong_fields }
        
        it 'marks the contacts with errors in the logs' do
          service.call
          expect(import.log['logs'].select {|log| log['error'] }.count).to eq(2)
        end
        
        it 'marks Import as failed' do
          service.call
          expect(import.reload.failed?).to be_truthy
        end
        
        it 'creates no Contacts' do
          expect { service.call }.to change { Contact.count }.by(0)
        end
      end
    end
  end
end
