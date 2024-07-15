# class PagesController < ApplicationController
#   before_action :set_client, only: [:update_stocks]

#   def home
#     @stocks = Stock.all
#     @orders = Order.all
#   end

#   def orders
#   end

#   def portfilio
#   end

#   def index
#     @stocks = Stock.all
#     @orders = Order.all
#     @greeting = 'hello_World'
#   end

#   def new
#     @order = Order.new
#     # debugger
#   end

#   def create
#     @stock = Stock.find_by(symbol: order_params[:symbol])
#     @trader_stocks = TraderStock.all.where(user_id: current_user.id)
#     @order = Order.new(order_params)
#     # debugger
#     if @order.save
#       if @order.order_type == "BUY"
#         order_price = -@order.price
#         order_quantity = -@order.quantity
#         if @trader_stocks.map(&:symbol).any? {|sym| sym == @order.symbol} && @trader_stocks.count > 0
#           @trader_stock = @trader_stocks.find_by(symbol: @order.symbol)
#           @trader_stock.add_to_quantity_of_existing_trader_stock @order.quantity
#         else
#           @trader_stock = TraderStock.create(
#             :user_id => order_params[:user_id].to_i,
#             :symbol => order_params[:symbol],
#             :price => order_params[:price].to_i,
#             :quantity => order_params[:quantity].to_i
#           )
#         end
#       else
#         # debugger
#         order_price = @order.price
#         order_quantity = @order.quantity
#         @trader_stock = @trader_stocks.find_by(symbol: @order.symbol)
#         @trader_stock.update_trader_stock_quantity_when_sell order_quantity
#         if @trader_stock.quantity == 0
#           @trader_stock.destroy
#         end
#       end 
#       current_user.recalculate_balance order_price
#       @stock.update_stock_quantity order_quantity
#       # debugger
#       redirect_to root_path, notice: "Order was successful."
#     else
#       redirect_to root_path(user_id: current_user.id, symbol: @stock.symbol), alert: "Order was unsuccessful."
#     end
#   end

#   def set_stock
#     @stock = Stock.find_by(symbol: params[:symbol])
#   end

#   def set_order
#     @order = Order.find(params[:id])
#   end

#   def order_params
#     params.require(:order).permit(:order_type, :price, :quantity, :symbol, :user_id)
#   end

#   def transact_order
#   end

#   def index
#     @stocks = Stock.where.not(high: nil)
#   end

#   def update_stocks
#     @stocks = Stock.all
#     @stocks.each do |stock|
#       stock_data = @client.fetch_stock_data(stock.symbol)
#       if stock_data
#         stock.update(
#           open: stock_data['open'],
#           high: stock_data['high'],
#           low: stock_data['low'],
#           close: stock_data['close'],
#           volume: stock_data['volume']
#         )
#       end
#     end
#     redirect_to root_path, notice: "Stocks updated successfully."
#   rescue StandardError => e
#     redirect_to root_path, alert: "Failed to update stocks: #{e.message}"
#   end

#   def show
#   end

#   def new
#     @stock = Stock.new
#   end

#   def create
#     @stock = Stock.new(stock_params)
#     if @stock.save
#       redirect_to @stock, notice: 'Stock was successfully created.'
#     else
#       render :new
#     end
#   end

#   def edit
#   end

#   def update
#     if @stock.update(stock_params)
#       redirect_to @stock, notice: 'Stock was successfully updated.'
#     else
#       render :edit
#     end
#   end

#   def destroy
#     @stock.destroy
#     redirect_to stocks_url, notice: 'Stock was successfully destroyed.'
#   end

#   private

#   def set_stock
#     @stock = Stock.find(params[:id])
#   end

#   def set_client
#     @client ||= AlphavantageService.new(ENV['ALPHAVANTAGE_API_KEY'])
#   end

#   def stock_params
#     params.require(:stock).permit(:company_name, :symbol, :logo, :price, :quantity)
#   end
# end

class PagesController < ApplicationController
  before_action :set_client, only: [:update_stocks]

  def home
    @stocks = Stock.all
    @orders = Order.all
  end

  def orders
    @orders = Order.all
  end

  def portfolio
    @trader_stocks = TraderStock.where(user_id: current_user.id)
  end

  def index
    @stocks = Stock.all
    @orders = Order.all
    @greeting = 'hello_World'
  end

  def new
    @order = Order.new
  end

  def create
    @stock = Stock.find_by(symbol: order_params[:symbol])
    @trader_stocks = TraderStock.where(user_id: current_user.id)
    @order = Order.new(order_params)

    if @order.save
      if @order.order_type == "BUY"
        handle_buy_order
      else
        handle_sell_order
      end 
      current_user.recalculate_balance order_price
      @stock.update_stock_quantity order_quantity
      redirect_to root_path, notice: "Order was successful."
    else
      redirect_to root_path(user_id: current_user.id, symbol: @stock.symbol), alert: "Order was unsuccessful."
    end
  end

  def update_stocks
    @stocks = Stock.all
    @stocks.each do |stock|
      stock_data = @client.fetch_stock_data(stock.symbol)
      if stock_data
        stock.update(
          open: stock_data['open'],
          high: stock_data['high'],
          low: stock_data['low'],
          close: stock_data['close'],
          volume: stock_data['volume']
        )
      end
    end
    redirect_to root_path, notice: "Stocks updated successfully."
  rescue StandardError => e
    redirect_to root_path, alert: "Failed to update stocks: #{e.message}"
  end

  private

  def handle_buy_order
    order_price = -@order.price
    order_quantity = -@order.quantity
    if @trader_stocks.exists?(symbol: @order.symbol)
      @trader_stock = @trader_stocks.find_by(symbol: @order.symbol)
      @trader_stock.add_to_quantity_of_existing_trader_stock @order.quantity
    else
      @trader_stock = TraderStock.create(
        user_id: order_params[:user_id].to_i,
        symbol: order_params[:symbol],
        price: order_params[:price].to_i,
        quantity: order_params[:quantity].to_i
      )
    end
  end

  def handle_sell_order
    order_price = @order.price
    order_quantity = @order.quantity
    @trader_stock = @trader_stocks.find_by(symbol: @order.symbol)
    @trader_stock.update_trader_stock_quantity_when_sell order_quantity
    @trader_stock.destroy if @trader_stock.quantity == 0
  end

  def set_stock
    @stock = Stock.find_by(symbol: params[:symbol])
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:order_type, :price, :quantity, :symbol, :user_id)
  end

  def set_client
    @client ||= AlphavantageService.new(ENV['ALPHAVANTAGE_API_KEY'])
  end

  def stock_params
    params.require(:stock).permit(:company_name, :symbol, :logo, :price, :quantity)
  end
end

       

