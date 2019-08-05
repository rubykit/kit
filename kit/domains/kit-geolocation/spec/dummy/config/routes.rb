Rails.application.routes.draw do
  mount Kit::Geolocation::Engine => "/kit-geolocation", as: 'kit_geolocation'

  root to: "home#index"
end
