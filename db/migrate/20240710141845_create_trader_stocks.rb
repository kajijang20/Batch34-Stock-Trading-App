class CreateTraderStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :trader_stocks do |t|

      t.timestamps
    end
  end
end
