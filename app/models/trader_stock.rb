class TraderStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  def add_to_quantity_of_existing_trader_stock(quantity)
    update(quantity: self.quantity + quantity)
  end

  def update_trader_stock_quantity_when_sell(quantity)
    update(quantity: self.quantity - quantity)
  end
end
