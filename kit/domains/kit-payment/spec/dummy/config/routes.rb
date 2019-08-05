Rails.application.routes.draw do
  mount Kit::Payment::Engine => "/kit-payment", as: 'kit_payment'

  root to: "home#index"
end
