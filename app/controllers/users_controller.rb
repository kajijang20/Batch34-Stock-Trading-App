class UsersController < ApplicationController
    before_action :set_user, only: %i[ update ]
    before_action :authenticate_user!
  
    def index
      @users = current_user
      @trader_stocks = TraderStock.where(user_id: current_user.id)
      @stocks = Stock.all
    end
  
    def update
      if params[:commit] == "Deposit"
        result = current_user.balance.to_f + params[:user][:balance].to_f
      else
        return if params[:user][:balance].to_f > current_user.balance.to_f
        result = current_user.balance.to_f - params[:user][:balance].to_f
      end
  
      if @user.update(balance: result)
        redirect_to dashboard_path
      end
    end
  
    private
  
    def set_user
      @user = User.where(id: current_user.id)
    end
end
