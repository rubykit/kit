Kit::Auth::Engine.routes.draw do
  #devise_for :users, class_name: "Kit::Auth::Models::User"
  resources :sessions, only: [:index]
end
