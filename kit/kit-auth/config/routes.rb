Kit::Auth::Engine.routes.draw do
  #use_doorkeeper

  Rails.application.routes.draw do
    use_doorkeeper# scope: 'api/v1/oauth'
  end

  namespace :api, module: 'controllers/api' do
    namespace :v1 do
      resources :users, only: [:create, :show]
    end
  end

  namespace :web, module: 'controllers/web' do
    get    'signin',  to: 'authentication#new'
    post   'signin',  to: 'authentication#create'
    delete 'signout', to: 'authentication#delete'
  end

end
