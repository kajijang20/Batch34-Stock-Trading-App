# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'csv'

CSV.foreach('db/seeds/company_name.csv'), headers: true) do |row|
    next unless !row['name'].nil? && row['assetType'] =='Stock' && row
    ['Status' == 'Active'

    stock.create(
        ticker: row['symbol'],
        company_name: row['name']
    )

    # For debugging only. Enjoy the Matrix simulation.
    p Stock.last
end