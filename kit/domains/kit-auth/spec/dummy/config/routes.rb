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

      'web|authorization_tokens|new'     => { path: '/web/sign-in',  verb: :get },
      'web|authorization_tokens|create'  => { path: '/web/sign-in',  verb: :post },
      'web|authorization_tokens|destroy' => { path: '/web/sign-out', verb: :delete },
      'web|authorization_tokens|index'   => { path: '/web/settings/devices', verb: :get },

      'web|users|reset_password_request|new'    => { path: '/web/reset-password',  verb: :get },
      'web|users|reset_password_request|create' => { path: '/web/reset-password',  verb: :post },

      'web|users|reset_password|edit'   => { path: '/web/update-password',  verb: :get },
      'web|users|reset_password|update' => { path: '/web/update-password',  verb: :put },

      'web|users|new'    => { path: '/web/sign-up',          verb: :get },
      'web|users|create' => { path: '/web/sign-up',          verb: :post },

      #'web|users|edit'   => { path: '/web/settings/account', verb: :get },
      #'web|users|update' => { path: '/web/settings/account', verb: :put },
    },
  )

  # Local to this app

  Kit::Router.register(uid: 'app|home', aliases: ['web|users|after_sign_in', 'web|users|after_sign_up'], controller: HomeController, action: :index)

  Kit::Router.map_routes(
    context: self,
    list: {
      'app|home' => { path: '/', verb: :get },
    },
  )

  #root to: "home#index"
end
