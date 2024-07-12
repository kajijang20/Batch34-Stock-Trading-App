class PagesController < ApplicationController
  before_action :set_client, only: [:update_stocks]

  def home
    @stocks = Stock.all
    @orders = Order.all
    @greeting = 'hello_World'
  end

  def orders
  end

  def portfilio
  end

  def index
    @stocks = Stock.all
    @orders = Order.all
    @greeting = 'hello_World'
  end

  def new
    @order = Order.new
    # debugger
  end

  def create
    @stock = Stock.find_by(symbol: order_params[:symbol])
    @trader_stocks = TraderStock.all.where(user_id: current_user.id)
    @order = Order.new(order_params)
    # debugger
    if @order.save
      if @order.order_type == "BUY"
        order_price = -@order.price
        order_quantity = -@order.quantity
        if @trader_stocks.map(&:symbol).any? {|sym| sym == @order.symbol} && @trader_stocks.count > 0
          @trader_stock = @trader_stocks.find_by(symbol: @order.symbol)
          @trader_stock.add_to_quantity_of_existing_trader_stock @order.quantity
        else
          @trader_stock = TraderStock.create(
            :user_id => order_params[:user_id].to_i,
            :symbol => order_params[:symbol],
            :price => order_params[:price].to_i,
            :quantity => order_params[:quantity].to_i
          )
        end
      else
        # debugger
        order_price = @order.price
        order_quantity = @order.quantity
        @trader_stock = @trader_stocks.find_by(symbol: @order.symbol)
        @trader_stock.update_trader_stock_quantity_when_sell order_quantity
        if @trader_stock.quantity == 0
          @trader_stock.destroy
        end
      end 
      current_user.recalculate_balance order_price
      @stock.update_stock_quantity order_quantity
      # debugger
      redirect_to root_path, notice: "Order was successful."
    else
      redirect_to root_path(user_id: current_user.id, symbol: @stock.symbol), alert: "Order was unsuccessful."
    end
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

  def transact_order
  end

  def stock
    @stocks = Stock.all
    @stocks =Stock.where.not(high: nil)
  end

  def update_stocks
    @stocks.each do |stock|
      stock_data = @client.fetch_stock_data(stock.symbol)
      # Process stock_data as needed and update Stock attributes
    end
    redirect_to root_path, notice: "Stocks updated successfully."
  rescue StandardError => e
    redirect_to root_path, alert: "Failed to update stocks: #{e.message}"
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

    private

      def set_stock
        @stock = Stock.find(params[:id])
      end

    def set_client
      @client = AlphavantageService.new(ENV['ALPHAVANTAGE_API_KEY'])
    end

      def stock_params
        params.require(:stock).permit(:company_name, :symbol, :logo, :price, :quantity)
      end
end
