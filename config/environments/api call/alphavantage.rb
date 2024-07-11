module Stock
    class import
        attr_reader :client

        def initialize
            @client = Alphavantage::Timeseries.new key: ENV['ALPHAVANTAGE_API_KEY']
        end

        def call
        end
    end
end