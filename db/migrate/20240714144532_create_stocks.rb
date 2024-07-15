class CreateStocks < ActiveRecord::Migration[7.1]
  #drop_table :stocks, if_exists: true 

  def change
    create_table :stocks do |t|
      t.string :symbol
      t.decimal :open
      t.decimal :high
      t.decimal :low
      t.decimal :close
      t.integer :volume
      t.string :data

      t.timestamps
    end
  end
end
