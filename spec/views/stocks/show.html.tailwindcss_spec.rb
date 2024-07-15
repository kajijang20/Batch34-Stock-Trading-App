require 'rails_helper'

RSpec.describe "stocks/show", type: :view do
  before(:each) do
    @stock = assign(:stock, Stock.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
