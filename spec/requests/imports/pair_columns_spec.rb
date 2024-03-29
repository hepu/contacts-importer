require 'rails_helper'

RSpec.describe "Imports::PairColumns", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/imports/pair_columns/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/imports/pair_columns/update"
      expect(response).to have_http_status(:success)
    end
  end

end
