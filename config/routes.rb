Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  resources :users, only: [:index, :new, :create]
  get "users/login", to: "users#login"
  post "users/login", to: "users#authentication"
  get "users/logout", to: "users#logout"
  root "users#new"
end
