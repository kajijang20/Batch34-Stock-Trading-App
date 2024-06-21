Rails.application.routes.draw do
  devise_for :histories
  devise_for :trader_stocks
  devise_for :stocks
  devise_for :orders
  devise_for :portfolios
  devise_for :homes
  devise_for :users

  # devise_for :admin, controllers: {
  #   sessions: 'admin,sessions',
  #   registrations: 'admin/registrations'
  # }

  # devise_for :users, controllers: {
  #   sessions: 'users/sessions'
  # }

  # root 'pages#home'
  # get 'pages/orders'
  # get 'pages/stock'
  # get 'pages/trader_stocks'
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # get 'pages/users'
  # get 'pages/admin'     
  
end
