class Order < ApplicationRecord
    belongs_to :user
    validates :order_type, :price, :quantity, :user_id, :symbol, presence: true
    validates :order_type, inclusion: { in: %w[BUY SELL] }
    validates :price, numericality: { greater_than: 0 }
    validates :quantity, numericality: { greater_than: 0 }, presence: true

    validate do 
      if !user_balance_sufficient?
        errors.add :balance, "Insufficient User Balance"
      end
    end

    validate do
      if !can_trader_sell_trader_stocks?
        errors.add :quantity, "Insufficient Quantity"
      end
    end

    before_save :compute_total_order_price
    
    private
  
    def can_trader_sell_trader_stocks? #trader_stocks
      if order_type == "SELL"
        trader_stock = user.trader_stocks.find_by(symbol: symbol)
        return false if trader_stock.nil? || quantity.nil?
        return false if trader_stock.quantity < quantity
        return true
      else
        return true
      end
    end

    def compute_total_order_price
      self.price = quantity * self.price
    end
  
    def user_balance_sufficient?
      return false if price.nil? || quantity.nil?
      return false if order_type == "BUY" && (user.balance < (price * quantity))
      return true
    end
end

