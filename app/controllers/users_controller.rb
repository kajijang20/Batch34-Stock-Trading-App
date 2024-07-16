# class UsersController < ApplicationController
#     #before_action :set_user, only: [:show, :edit, :update]
#     #after_action :verify_authorized, except: [:index]
#     belongs_to :user
#     belongs_to :stock
  
#     def index
#       #authorize :index
#       @users = Users.all
#       @trader_stocks = TraderStock.where(user_id: current_user.id)
#       @stocks = Stock.all
#     end

#     def show
#       #authorize @user
#     end
  
#     def edit
#       #authorize @user
#     end
  
#     def update
#       #authorize @user
#       if params[:commit] == "Deposit"
#         result = current_user.balance.to_f + params[:user][:balance].to_f
#       else
#         return if params[:user][:balance].to_f > current_user.balance.to_f
#         result = current_user.balance.to_f - params[:user][:balance].to_f
#       end
  
#       if @user.update(balance: result)
#         redirect_to dashboard_path
#       end
#     end

#     def userlist
#       @users = User.with_role(:admin)
#     end
  
#     def transactions
#       # Action restricted to admin only
#       @users = User.with_role(:admin)
#     end
  
#     private
  
#     def set_user
#       @user = User.find(params[:id])
#     end

#     def check_admin
#       unless current_user.has_role?(:admin)
#         redirect_to root_path, alert: "You are not authorized to access this page."
#       end
#     end
# end

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]
  before_action :check_admin, only: %i[userlist transactions]

  def index
    @users = User.all
    @trader_stocks = TraderStock.where(user_id: current_user.id)
    @stocks = Stock.all
  end

  def show
  end

  def edit
  end

  def update
    if params[:commit] == "Deposit"
      result = current_user.wallet.to_f + params[:user][:wallet].to_f
    else
      if params[:user][:wallet].to_f > current_user.wallet.to_f
        redirect_to edit_user_path(@user), alert: "Insufficient funds."
        return
      end
      result = current_user.wallet.to_f - params[:user][:wallet].to_f
    end

    if current_user.update(wallet: result)
      redirect_to dashboard_path, notice: "Balance updated successfully."
    else
      render :edit, alert: "Failed to update balance."
    end
  end

  def userlist
    @users = User.with_role(:admin)
  end

  def transactions
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

  def user_params
    params.require(:user).permit(:wallet)
  end
end
