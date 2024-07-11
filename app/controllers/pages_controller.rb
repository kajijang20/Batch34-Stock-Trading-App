class PagesController < ApplicationController
  before_action :set_stock, only: %i[ index new create edit destroy]
  before_action :set_order, only: %i[ show edit update destroy ]
  before_action :authenticate_user!


  def home
    @stocks = Stock.all
    @orders = Order.all
    @greeting = 'hello_World'
  end

<<<<<<< HEAD
  # def orders

  #   authorize Order
  # end

  # def create
  #   @order = Order.new(order_params)
  #   authorize @order
  # end

  # def update
  #   @order = Order.find(params[:id])
  #   authorize @order
  # end

  # def destroy
  #   @order = Order.find(params[:id])
  #   authorize @order
  # end
  
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
    # @order.user_balance_sufficient?
    
    # @order.check_if_user_can_sell_trader_stocks #@trader_stocks

    # @order.recalculate_user_balance
    # debugger
    # if order_params[:order_type] == "BUY"
    # else

    # end
    # debugger

    if @order.save
      # @order.order_type == "BUY" ? price = -@order.price : price = @order.price
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
      
      redirect_to home_path, notice: "Order was successful."
    else
      redirect_to home_path(user_id: current_user.id, symbol: @stock.symbol), alert: "Order was unsuccessful."
    end
  end

  def edit
  end


  def set_stock
    # @stock = Stock.where(symbol: params[:symbol])
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
    @stocks = stock.all
    @stocks.each do |stock|
      Stocks::Import.new(self).call
    end

    redirect_to home_path 
  rescue StandardError => e
    redirect_to home_path
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
        @client = Alphavantage::Api::Client.new(key: ENV['ALPHAVANTAGE_API_KEY']
      
        )
      end
    

      def stock_params
        params.require(:stock).permit(:company_name, :symbol, :logo, :price, :quantity)
      end
  

=======
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
      ccurrent_user.recalculate_balance order_price
      @stock.update_stock_quantity order_quantity
      # debugger
      redirect_to home_path, notice: "Order was successful."
    else
      redirect_to home_path(user_id: current_user.id, symbol: @stock.symbol), alert: "Order was unsuccessful."
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
    @stocks = stock.all
    @stocks.each do |stock|
      Stocks::Import.new(self).call
    end
    redirect_to home_path 
  rescue StandardError => e
    redirect_to home_path
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
      @client = Alphavantage::Api::Client.new(key: ENV['ALPHAVANTAGE_API_KEY'])
    end

    def stock_params
      params.require(:stock).permit(:company_name, :symbol, :logo, :price, :quantity)
    end

    def trader_stocks

      def index
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
    end
end
