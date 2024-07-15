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
admin_user = User.find_or_create_by(email: 'admin@example.com') do |user|
    user.password = 'admin'  # Replace 'password' with the actual password
end
admin_user.add_role(:admin)
  
trader_user = User.find_or_create_by(email: 'trader@example.com') do |user|
    user.password = 'password'  # Replace 'password' with the actual password
end
trader_user.add_role(:trader)


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
  #puts "stock created: #{Stock.last.symbol}"
end
puts "stocks created: #{Stock.count}"