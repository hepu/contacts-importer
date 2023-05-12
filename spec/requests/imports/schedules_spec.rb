require 'rails_helper'

RSpec.describe "Imports::Schedules", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/imports/schedules/create"
      expect(response).to have_http_status(:success)
    end
  end

end
