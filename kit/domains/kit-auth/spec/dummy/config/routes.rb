Rails.application.routes.draw do
  mount Kit::Auth::Engine => "/kit-auth", as: 'kit_auth'

  root to: "home#index"
end
