class Stock < ApplicationRecord
    has_many :trader_stocks
    has_many :portfolios, through: :trader_stocks
    has_many :orders
  
    def update_stock_quantity(order_quantity)
      update(quantity: quantity + order_quantity)
    end
  
    def update_existing_stock_price(new_price)
      update(price: new_price)
    end
  
    def import_update
      Stocks::Import.new(self).call if ticker.present?
    end
  end
  