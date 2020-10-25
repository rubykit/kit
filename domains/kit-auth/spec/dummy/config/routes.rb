Rails.application.routes.draw do
  #mount Kit::Auth::Engine => "/kit-auth", as: 'kit_auth'

  list_api = [
    { id: 'api_v1|users|show',                       path: '/api/users/:resource_id',                verb: :get,     namespace: [:users] },
    { id: 'api_v1|users|create',                     path: '/api/users',                             verb: :post,    namespace: [:users] },

    { id: 'api_v1|authorization_tokens|show',        path: '/api/authorization_tokens/:resource_id', verb: :get,     namespace: [:authorization] },
    { id: 'api_v1|authorization_tokens|index',       path: '/api/authorization_tokens',              verb: :get,     namespace: [:authorization] },
    { id: 'api_v1|authorization_tokens|create',      path: '/api/authorization_tokens',              verb: :post,    namespace: [:authorization] },
  ]

  list_api.each do |entry|
    entry.merge!({
      rails_endpoint_wrapper: [::ApiController, :route],
      namespace:              [:kit_auth, :api].concat(entry[:namespace] || []),
    })
  end

  Kit::Router::Services::Adapters::Http::Rails::Routes.mount_http_targets(rails_router_context: self, list: list_api, namespace: [:kit_auth, :api])

  list_web = [
    { id: 'web|authorization_tokens|new',            path: '/web/sign-in',                           verb: :get,    namespace: [:authorization] },
    { id: 'web|authorization_tokens|create',         path: '/web/sign-in',                           verb: :post,   namespace: [:authorization] },
    { id: 'web|authorization_tokens|destroy',        path: '/web/sign-out',                          verb: :delete, namespace: [:authorization] },
    { id: 'web|authorization_tokens|index',          path: '/web/settings/devices',                  verb: :get,    namespace: [:authorization] },

    { id: 'web|users|reset_password_request|new',    path: '/web/reset-password',                    verb: :get,    namespace: [:password] },
    { id: 'web|users|reset_password_request|create', path: '/web/reset-password',                    verb: :post,   namespace: [:password] },

    { id: 'web|users|reset_password|edit',           path: '/web/update-password',                   verb: :get,    namespace: [:password] },
    { id: 'web|users|reset_password|update',         path: '/web/update-password',                   verb: :put,    namespace: [:password] },

    { id: 'web|users|new',                           path: '/web/sign-up',                           verb: :get,    namespace: [:users] },
    { id: 'web|users|create',                        path: '/web/sign-up',                           verb: :post,   namespace: [:users] },

    #{ id: 'web|users|sign_in',                       path: '/web/sign-inn',                          verb: :post },
  ]

  list_web.each do |entry|
    entry.merge!({
      rails_endpoint_wrapper: [::WebController, :route],
      namespace:              [:kit_auth, :web].concat(entry[:namespace] || []),
    })
  end

  Kit::Router::Services::Adapters::Http::Rails::Routes.mount_http_targets(rails_router_context: self, list: list_web)



  list_admin = []

  Kit::Router::Services::Adapters::Http::Rails::Routes.mount_http_targets(rails_router_context: self, list: list_admin)


  # ----------------------------------------------------------------------------
  # Local to this app container

  list_local = [
    { id: 'app|home', path: '/', verb: :get },
  ]

  Kit::Router::Services::Adapters::Http::Rails::Routes.mount_rails_targets(rails_router_context: self, list: list_local)

end
