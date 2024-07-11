class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.string :price
      t.string :open
      t.string :high
      t.string :low
      t.string :volume
      t.json :data

      t.timestamps
    end
  end
end
