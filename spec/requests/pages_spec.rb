require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /home" do
    it "returns http success" do
      get "/pages/home"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /orders" do
    it "returns http success" do
      get "/pages/orders"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /stock" do
    it "returns http success" do
      get "/pages/stock"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /trader_stocks" do
    it "returns http success" do
      get "/pages/trader_stocks"
      expect(response).to have_http_status(:success)
    end
  end

end
