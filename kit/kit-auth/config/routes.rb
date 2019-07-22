Kit::Auth::Engine.routes.draw do
  use_doorkeeper

  namespace :api, module: 'controllers/api' do
    namespace :v1 do
      resources :users, only: [:create, :show]
    end
  end
end
