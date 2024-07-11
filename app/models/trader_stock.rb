class TraderStock < ApplicationRecord
    belongs_to :user

    def update_trader_stock_quantity_when_sell order_quantity
      update(quantity: quantity - order_quantity)
    end

    def add_to_quantity_of_existing_trader_stock order_quantity
      update(quantity: quantity + order_quantity)
    end
end
