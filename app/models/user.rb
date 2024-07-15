class User < ApplicationRecord
  after_create :send_welcome_email
  before_create :initialize_wallet
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :trader_stocks
  has_many :orders
  rolify

  def has_role?(role)
    roles.any? { |r| r.name.underscore.to_sym == role }
  end

  enum status: { pending: 0, approved: 1 }, _default: :pending

  # Initialize wallet with $50,000,000 on user creation
  def initialize_wallet
    self.wallet = 50000000
  end

  # Recalculate the wallet balance
  def recalculate_balance(amount)
    update(wallet: wallet + amount)
  end

  private

  def send_welcome_email
    # You can replace this with your actual implementation to send the email
    UserMailer.welcome_email(self).deliver_now
  end
end
