require 'alphavantage'

Alphavantage.configure do |config|
    config.api_key = ENV['ALPHAVANTAGE_API_KEY']
end