require 'rails_helper'

RSpec.describe ImportsController, type: :controller do
  let(:parsed_response) { JSON.parse(response.body) }
  let!(:user) { create(:user) }
  let(:file_happy_path) { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/example_happy_path.csv") }

  describe 'GET index' do
    subject { get(:index) }
    
    let!(:imports) { create_list(:import, 10) }
    
    context 'with no authentication' do
      it { is_expected.to have_http_status(:found) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
    
    context 'with authentication' do
      before do
        sign_in(user)
      end
      
      it { is_expected.to have_http_status(:ok) }
    end
  end
  
  describe 'GET new' do
    subject { get(:new) }
    
    context 'with no authentication' do
      it { is_expected.to have_http_status(:found) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
    
    context 'with authentication' do
      before do
        sign_in(user)
      end
      
      it { is_expected.to have_http_status(:ok) }
    end
  end
  
  describe 'POST create' do
    subject(:post_request) { post(:create, params: params) }
    
    let(:params) do
      { import: { file: file_happy_path } }
    end
    
    context 'with no authentication' do
      it { is_expected.to have_http_status(:found) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
    
    context 'with authentication' do
      before do
        sign_in(user)
      end

      it { is_expected.to redirect_to(pair_columns_import_path(Import.last, continue: true)) }

      it 'creates a new Import' do
        expect { post_request }.to change { Import.count }.by(1)
      end
    end
  end
  
  describe 'GET pair_columns' do
    subject(:get_request) { get(:pair_columns, params: params) }
    
    let(:import) { create(:import, user: user, file: file_happy_path) }
    let(:params) { { id: import.id } }
    
    context 'with no authentication' do
      it { is_expected.to have_http_status(:found) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
    
    context 'with authentication' do
      before do
        sign_in(user)
      end

      it { is_expected.to have_http_status(:ok) }
    end
  end
  
  describe 'GET show' do
    subject(:get_request) { get(:show, params: params) }
    
    let(:import) { create(:import, user: user, file: file_happy_path) }
    let(:params) { { id: import.id } }
    
    context 'with no authentication' do
      it { is_expected.to have_http_status(:found) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
    
    context 'with authentication' do
      before do
        sign_in(user)
      end

      it { is_expected.to have_http_status(:ok) }
    end
  end
  
  describe 'PUT update' do
    subject(:put_request) { put(:update, params: params) }
    
    let(:params) do
      { id: import.id, import: { columns_pair: columns_pair } }
    end
    let(:import) { create(:import, user: user, file: file_happy_path) }
    let(:columns_pair) do
      { name: 'Nombre', address: 'Street Address' }
    end
    
    context 'with no authentication' do
      it { is_expected.to have_http_status(:found) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
    
    context 'with authentication' do
      before do
        sign_in(user)
      end

      it { is_expected.to redirect_to(import_path(import)) }

      it 'updates columns_pair for Import' do
        put_request
        expect(import.reload.columns_pair).to eq(columns_pair.stringify_keys)
      end
    end
  end
  
  describe 'DELETE destroy' do
    subject(:delete_request) { delete(:destroy, params: params) }
    
    let(:params) do
      { id: import.id }
    end
    let(:import) { create(:import, user: user, file: file_happy_path) }
    
    context 'with no authentication' do
      it { is_expected.to have_http_status(:found) }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
    
    context 'with authentication' do
      before do
        sign_in(user)
      end

      it { is_expected.to redirect_to(imports_path) }

      it 'deletes the Import' do
        delete_request
        expect(Import.exists?(import.id)).to be_falsey
      end
    end
  end
end
