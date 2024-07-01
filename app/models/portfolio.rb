class Portfolio < ApplicationRecord
  has_many :stocks, through: :trader_stocks
  has_many :trader_stocks
  has_many :orders
  has_many :histories
end
