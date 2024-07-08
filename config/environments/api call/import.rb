module Stocks
    class import
        attr_reader :stock, :stock, :stock_timeseries

        def initialize(stock)
            @stock = stock@
            @stock_qoute = Alphavantage::Stock.new(symbol: stock.ticker,
            key ENV['ALPHAVANTAGE_API_KEY']).qoute
        end

        def call
            stock.update(
                price: stock_timeseries.price,
                open: stock_timeseries.open,
                high: stock_timeseries.high,
                low: stock_timeseries.low,
                volume: stock_timeseries.volume,
                data: stock_timeseries.data
            )
        end
    end
end