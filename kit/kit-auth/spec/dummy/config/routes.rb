Rails.application.routes.draw do
  mount Kit::Auth::Engine => "/kit-auth"

  root to: "home#index"
end
