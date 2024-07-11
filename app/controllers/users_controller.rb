class UsersController < ApplicationController
    #before_action :set_user, only: [:show, :edit, :update]
    #after_action :verify_authorized, except: [:index]
  
    def index
      #authorize :index
      @users = Users.all
      @trader_stocks = TraderStock.where(user_id: current_user.id)
      @stocks = Stock.all
    end

    def show
      #authorize @user
    end
  
    def edit
      #authorize @user
    end
  
    def update
      #authorize @user
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

    def userlist
      @users = User.with_role(:admin)
    end
  
    def transactions
      # Action restricted to admin only
      @users = User.with_role(:admin)
    end
  
    private
  
    def set_user
      @user = User.find(params[:id])
    end

    def check_admin
      unless current_user.has_role?(:admin)
        redirect_to root_path, alert: "You are not authorized to access this page."
      end
    end
end
