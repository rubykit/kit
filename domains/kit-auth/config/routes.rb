Kit::Auth::Engine.routes.draw do
  #use_doorkeeper

  #Rails.application.routes.draw do
  #  use_doorkeeper # scope: 'api/v1/oauth'
  #end

  Kit::Auth::Admin.routes(self)

  namespace :api, module: 'controllers/api' do
    namespace :v1 do
      resources :users,                only: [:show]
      resources :authorization_tokens, only: [:index, :create, :show]
    end
  end

  namespace :web, module: 'controllers/web' do
    get    'signin',  to: 'authentication#new'
    post   'signin',  to: 'authentication#create'
    delete 'signout', to: 'authentication#delete'

    get 'users/settings/devices', to: 'oauth_access_tokens#index'
  end

end
