module Stock
    class import
        attr_reader :client

        def initialize
            @client = Alphavantage::Timeseries.new key: ENV
            ['ALPHAVANTAGE_API']
        end

        def call
        end
    end
end