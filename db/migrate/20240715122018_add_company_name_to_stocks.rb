class AddCompanyNameToStocks < ActiveRecord::Migration[7.1]
  def change
    add_column :stocks, :company_name, :string
  end
end
