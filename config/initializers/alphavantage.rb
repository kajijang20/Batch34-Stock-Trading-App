# config/initializers/alphavantage.rb (example initialization)
module StockImport
    class Import
      attr_reader :client
  
      def initialize(symbol:)
        @client = Alphavantage::Timeseries.new(key: ENV['ALPHAVANTAGE_API_KEY'])
        @symbol = symbol
      end
  
      def call
        # Your implementation here
      end
    end
  end
  