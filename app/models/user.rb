class User < ApplicationRecord
  after_create :send_welcome_email
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         has_many :trader_stocks
         has_many :orders

  enum :status, { pending: 0, approved: 1 }, default: :pending

  def recalculate_balance price
    # if order_type == "BUY"
    update(balance: balance + price)
  end

  private

  def send_welcome_email
    WelcomeMailer.with(email: email).welcome_email.deliver_now
  end
end


