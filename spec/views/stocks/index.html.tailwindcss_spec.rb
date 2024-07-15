require 'rails_helper'

RSpec.describe "stocks/index", type: :view do
  before(:each) do
    assign(:stocks, [
      Stock.create!(),
      Stock.create!()
    ])
  end

  it "renders a list of stocks" do
    render
  end
end
