module StockImport
  class Import
    attr_reader :stock#, :stock_timeseries
  
    def initialize(stock)
      @stock = stock
      #@stock_timeseries = Alphavantage::Stock.new(
      #  symbol: stock.ticker,
      #  key: ENV['ALPHAVANTAGE_API_KEY']
      #).quote
    end
  
    def call
      return false unless fetch_stock_data

      stock.update(
        #price: stock_timeseries.price,
        open: stock_timeseries['open'],
        high: stock_timeseries['high'],
        low: stock_timeseries['low'],
        close: stock_timeseries['previous_close'],
        volume: stock_timeseries['volume'],
        #data: stock_timeseries.data
      )
    end

    private

    def fetch_stock_data
      alpha_vantage = Alphavantage::Client.new(key: ENV['ALPHAVANTAGE_API_KEY'])
      alpha_vantage.verbose = true

      begin
        @stock_timeseries = alpha_vantage.stock(symbol: @stock.symbol).quote
        return true if @stock_timeseries.present?
        puts "Failed to fetch data for #{@stock.symbol} from AlphaVantage"
        return false
      rescue Alphavantage::Error => e
        puts "AlphaVantage API error: #{e.message}"
        return nil
      end
    end
  end
end
  