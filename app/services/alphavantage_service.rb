# app/services/alphavantage_service.rb
require 'alphavantagerb'

class AlphavantageService
  def initialize(api_key)
    @client = Alphavantage::Client.new(api_key: ENV['ALPHAVANTAGE_API_KEY'])
  end

  def fetch_stock_data(symbol)
    @client.stock(symbol: symbol, datatype: 'json')
  end
end
