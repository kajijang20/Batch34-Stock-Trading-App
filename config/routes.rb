Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root 'pages#home'
  
  get '/' => 'pages#home'
  #get '/search', to: 'pages#search'
  get '/stocks/search', to: 'stocks#search', as: :stock_search
  
  get '/orders' => 'pages#orders'
  get '/update_stock', to: 'pages#update_stocks', as: 'updated_stocks'
  get '/userlist', to: 'users#userlist'
  get '/transactions', to: 'users#transactions'

  resources :stocks
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
   
  delete '/users/sign_out', to: 'users/sessions#destroy'
  
end
