require 'rails_helper'

RSpec.describe ImportContactsJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later(import_id, user_id) }
  
  let(:file_happy_path) { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/example_happy_path.csv") }
  let(:file) { file_happy_path }
  let(:user) { create(:user) }
  let(:import) { create(:import, user: user, file: file) }
  let(:user_id) { user.id }
  let(:import_id) { import.id }
  
  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
  
  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class).with(import_id, user_id).on_queue('imports')
  end
  
  it 'is in imports queue' do
    expect(described_class.new.queue_name).to eq('imports')
  end
  
  it 'calls the import service' do
    expect_any_instance_of(ImportContactsService).to receive(:call)
    perform_enqueued_jobs { job }
  end
  
  it 'handles error and retry' do
    allow_any_instance_of(ImportContactsService).to receive(:call).and_raise(StandardError)

    perform_enqueued_jobs do
      expect_any_instance_of(described_class).to receive(:retry_job).with(wait: 3.minutes, queue: :default)

      job
    end
  end
end
