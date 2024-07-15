# class StocksController < ApplicationController
#   before_action :set_stock, only: %i[ show edit update destroy ]
# class StocksController < ApplicationController
#   before_action :set_stock, only:rta
#   before_action :set_client, only: %i[update_stocks create_order]

#   # GET /stocks
#   def index
#     @stocks = Stock.all
#   end

#   # GET /stocks/1
#   def show
#   end

#   # GET /stocks/new
#   def new
#     @stock = Stock.new
#   end

#   # GET /stocks/1/edit
#   def edit
#   end

#   # POST /stocks
#   def create
#     @stock = Stock.new(stock_params)

#     if @stock.save
#       redirect_to @stock, notice: "Stock was successfully created."
#     else
#       render :new, status: :unprocessable_entity
#     end
#   end

#   # PATCH/PUT /stocks/1
#   def update
#     if @stock.update(stock_params)
#       redirect_to @stock, notice: "Stock was successfully updated.", status: :see_other
#     else
#       render :edit, status: :unprocessable_entity
#     end
#   end

#   # DELETE /stocks/1
#   def destroy
#     @stock.destroy!
#     redirect_to stocks_url, notice: "Stock was successfully destroyed.", status: :see_other
#   end

#   private
#     # Use callbacks to share common setup or constraints between actions.
#     def set_stock
#       @stock = Stock.find(params[:id])
#     end

#     # Only allow a list of trusted parameters through.
#     def stock_params
#       params.fetch(:stock, {})
#     end
# end

class StocksController < ApplicationController
  before_action :set_stock, only: %i[show edit update destroy]
  before_action :set_client, only: %i[update_stocks create_order]

  # GET /stocks
  def index
    @stocks = Stock.all
    @orders = Order.all
  end

  # GET /stocks/1
  def show
  end

  # GET /stocks/new
  def new
    @stock = Stock.new
  end

  # GET /stocks/1/edit
  def edit
  end

  # POST /stocks
  def create_stock
    @stock = Stock.new(stock_params)

    if @stock.save
      redirect_to @stock, notice: "Stock was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /stocks/1
  def update
    if @stock.update(stock_params)
      redirect_to @stock, notice: "Stock was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /stocks/1
  def destroy
    @stock.destroy!
    redirect_to stocks_url, notice: "Stock was successfully destroyed.", status: :see_other
  end

  # POST /orders
  def create_order
    @stock = Stock.find_by(symbol: order_params[:symbol])
    @trader_stocks = TraderStock.where(user_id: current_user.id)
    @order = Order.new(order_params)

    if @order.save
      handle_order_transaction
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

  def set_stock
    @stock = Stock.find(params[:id])
  end

  def set_client
    @client ||= AlphavantageService.new(ENV['ALPHAVANTAGE_API_KEY'])
  end

  def stock_params
    params.require(:stock).permit(:company_name, :symbol, :logo, :price, :quantity)
  end

  def order_params
    params.require(:order).permit(:order_type, :price, :quantity, :symbol, :user_id)
  end

  def handle_order_transaction
    order_price = @order.order_type == "BUY" ? -(@order.price * @order.quantity) : @order.price * @order.quantity
    order_quantity = @order.order_type == "BUY" ? @order.quantity : -@order.quantity

    if @order.order_type == "BUY"
      handle_buy_order(order_quantity)
    else
      handle_sell_order(order_quantity)
    end

    current_user.recalculate_balance(order_price)
    @stock.update_stock_quantity(order_quantity)
  end

  def handle_buy_order(order_quantity)
    if @trader_stocks.exists?(symbol: @order.symbol)
      @trader_stock = @trader_stocks.find_by(symbol: @order.symbol)
      @trader_stock.add_to_quantity_of_existing_trader_stock(@order.quantity)
    else
      TraderStock.create(
        user_id: order_params[:user_id],
        symbol: order_params[:symbol],
        price: order_params[:price],
        quantity: order_params[:quantity]
      )
    end
  end

  def handle_sell_order(order_quantity)
    @trader_stock = @trader_stocks.find_by(symbol: @order.symbol)
    @trader_stock.update_trader_stock_quantity_when_sell(order_quantity)
    @trader_stock.destroy if @trader_stock.quantity.zero?
  end
end
