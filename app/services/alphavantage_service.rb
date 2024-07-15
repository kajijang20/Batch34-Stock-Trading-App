class AlphavantageService
  def initialize(api_key = ENV['ALPHAVANTAGE_API_KEY'])
    raise ArgumentError, 'API key is required' if api_key.nil? || api_key.empty?

    @client = Alphavantage::Client.new key: api_key
  end

  def fetch_stock_data(symbol)
    raise ArgumentError, 'Stock symbol is required' if symbol.nil? || symbol.empty?

    begin
      response = @client.stock(symbol: symbol, datatype: 'json')
      # Check if the response is successful and contains the expected data
      if response.success?
        response
      else
        raise "Error fetching stock data: #{response.error_message}"
      end
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
      nil
    end
  end
end
