Rails.application.routes.draw do
  mount Kit::Auth::Engine, at: '/'
end
