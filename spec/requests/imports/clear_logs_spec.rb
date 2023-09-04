require 'rails_helper'

RSpec.describe "Imports::ClearLogs", type: :request do
  describe "GET /destroy" do
    it "returns http success" do
      get "/imports/clear_logs/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
