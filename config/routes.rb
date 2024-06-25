Rails.application.routes.draw do
 
  devise_for :admin, controllers: {
    sessions: 'admin/sessions',
    registrations: 'admin/registrations'
  }

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  
  get '/' => 'pages#home'
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
  delete '/users/sign_out', to: 'users/sessions#destroy'
  delete '/admin/sign_out', to: 'admin/sessions#destroy'
end
