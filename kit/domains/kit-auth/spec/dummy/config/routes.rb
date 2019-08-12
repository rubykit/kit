Rails.application.routes.draw do
  #mount Kit::Auth::Engine => "/kit-auth", as: 'kit_auth'

  Kit::Router.map_routes(
    context: self,
    list: {
      'api_v1|users|show'   => { path: '/api/users/:resource_id', verb: :get },
      'api_v1|users|create' => { path: '/api/users',              verb: :post },

      'api_v1|authorization_tokens|show'   => { path: '/api/authorization_tokens/:resource_id', verb: :get },
      'api_v1|authorization_tokens|index'  => { path: '/api/authorization_tokens',              verb: :get },
      'api_v1|authorization_tokens|create' => { path: '/api/authorization_tokens',              verb: :post },

      'web|authorization_tokens|new'     => { path: '/authorization_tokens', verb: :get },
      'web|authorization_tokens|create'  => { path: '/authorization_tokens', verb: :post },
      'web|authorization_tokens|destroy' => { path: '/authorization_tokens', verb: :delete },
    },
  )

  # Local to this app

  Kit::Router.register(uid: 'app|home', aliases: ['web|users|after_sign_in'], controller: HomeController, action: :index)

  Kit::Router.map_routes(
    context: self,
    list: {
      'app|home' => { path: '/', verb: :get },
    },
  )

  #root to: "home#index"
end
