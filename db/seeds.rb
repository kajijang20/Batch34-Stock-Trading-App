# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

#require 'csv'
#require_relative '../config/environments/api_call/import'
#require 'alphavantagerb'

# Adjust the path to match your actual CSV file location
#csv_file = Rails.root.join('db', 'seeds', 'company_list.csv')
#alpha_vantage = Alphavantage::Client.new key: ENV['ALPHAVANTAGE_API_KEY']
#alpha_vantage.verbose = true

#Stock.destroy_all
#if Stock.count.zero?
#  CSV.foreach(csv_file, headers: true) do |row|
#    next unless row['name'].present? && row['assetType'] == 'Stock' && row['status'] == 'Active'
    #debugger
#    symbol = row['symbol']
#    stock = Stock.find_or_initialize_by(symbol: symbol)
#    data = alpha_vantage.stock(symbol: symbol)
    #data = Alphavantage::Stock.new(symbol: symbol, key: ENV['ALPHAVANTAGE_API_KEY'])

#    if data
#      latest_data = data.quote
#      open_price = latest_data['open']
#      high_price = latest_data['high']
#      low_price = latest_data['low']
#      close_price = latest_data['previous_close']
#      volume = latest_data['volume']
    
#      stock.assign_attributes(
#        symbol: symbol,
#        company_name: row['name'],
#        open: open_price,
#        close: close_price,
#        high: high_price,
#        low: low_price,
#        volume: volume
#      )

      #Stock.create(
      #  symbol: row['symbol'],
      #  company_name: row['name'],
      #  open: open_price,
      #  lose: close_price,
      #  high: high_price,
      #  low: low_price,
      #  volume: volume
      #)

      #import = StockImport::Import.new(stock)
      #import.call

      #if stock.save
      #  puts "Stock data imported successfully for #{symbol}"
      #else
      #  puts "Failed to import data for #{symbol}: #{stock.errors.full_messages.join(', ')}"
      #end
#    else
#     puts "Failed to fetch data for #{symbol} from AlphaVantage"
#    end
#  end

    #Stock.create(
    #  symbol: row['symbol'],
    #  company_name: row['name']
    #  open: row['']
    #  high: 
    #  low: 
    #  close: 
    #  volume: 
    #  data: 
    #)
#end
#puts "stocks created: #{Stock.count}"

# Create users with default roles
unless User.exists?(email: 'admin_trisha@gmail.com')
  admin_user1 = User.create!(
    email: 'admin_trisha@gmail.com',
    password: 'trishapassword',
    password_confirmation: 'trishapassword',
  )
  admin_user1.add_role(:admin)
  admin_user1.add_role(:approved_trader)
end

unless User.exists?(email: 'admin_anstley@gmail.com')
  admin_user2 = User.create!(
    email: 'admin_anstley@gmail.com',
    password: 'anstleypassword',
    password_confirmation: 'anstleypassword',
  )
  admin_user2.add_role(:admin)
  admin_user2.add_role(:approved_trader)
end

unless User.exists?(email: 'user1@gmail.com')
  trader_user = User.create!(
    email: 'user1@gmail.com',
    password: 'password',
    password_confirmation: 'password',
  )
  trader_user.add_role(:trader)
  trader_user.add_role(:approved_trader)
end
