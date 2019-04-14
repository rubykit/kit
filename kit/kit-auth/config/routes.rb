Kit::Auth::Engine.routes.draw do
  resources :sessions, only: [:index]
end
