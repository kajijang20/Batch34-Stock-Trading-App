# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create users with default roles
#debugger
admin_user = User.create!(
  email: 'admin_trisha@gmail.com',
  password: 'adminpassword',
  password_confirmation: 'adminpassword',
)
admin_user.add_role(:admin)
admin_user.add_role(:approved_trader)
  
trader_user = User.create!(
  email: 'user1@gmail.com',
  password: 'password',
  password_confirmation: 'password',
)
trader_user.add_role(:trader)
trader_user.add_role(:approved_trader)
### NOT WORKING ###


require 'csv'
# Adjust the path to match your actual CSV file location
csv_file = Rails.root.join('db', 'seeds', 'company_list.csv')
Stock.destroy_all
CSV.foreach(csv_file, headers: true) do |row|
  next unless row['name'].present? && row['assetType'] == 'Stock' && row['status'] == 'Active'

  Stock.create(
    symbol: row['symbol'],
    company_name: row['name']
  )
end
#puts "stocks created: #{Stock.count}"