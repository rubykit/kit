Rails.application.routes.draw do
  #mount Kit::Auth::Engine => "/kit-auth", as: 'kit_auth'

  list_api = [
    { id: 'api_v1|users|show',                       path: '/api/users/:resource_id',                verb: :get },
    { id: 'api_v1|users|create',                     path: '/api/users',                             verb: :post },

    { id: 'api_v1|authorization_tokens|show',        path: '/api/authorization_tokens/:resource_id', verb: :get },
    { id: 'api_v1|authorization_tokens|index',       path: '/api/authorization_tokens',              verb: :get },
    { id: 'api_v1|authorization_tokens|create',      path: '/api/authorization_tokens',              verb: :post },
  ]

  list_api.each do |entry|
    entry.merge!({
      rails_endpoint_wrapper: [::ApiController, :route],
    })
  end

  Kit::Router::Services::Adapters::Http::Rails::Routes.mount_http_targets(rails_router_context: self, list: list_api,)

  list_web = [
    { id: 'web|authorization_tokens|new',            path: '/web/sign-in',                           verb: :get },
    { id: 'web|authorization_tokens|create',         path: '/web/sign-in',                           verb: :post },
    { id: 'web|authorization_tokens|destroy',        path: '/web/sign-out',                          verb: :delete },
    { id: 'web|authorization_tokens|index',          path: '/web/settings/devices',                  verb: :get },

    { id: 'web|users|reset_password_request|new',    path: '/web/reset-password',                    verb: :get },
    { id: 'web|users|reset_password_request|create', path: '/web/reset-password',                    verb: :post },

    { id: 'web|users|reset_password|edit',           path: '/web/update-password',                   verb: :get },
    { id: 'web|users|reset_password|update',         path: '/web/update-password',                   verb: :put },

    { id: 'web|users|new',                           path: '/web/sign-up',                           verb: :get },
    { id: 'web|users|create',                        path: '/web/sign-up',                           verb: :post },
  ]

  list_web.each do |entry|
    entry.merge!({
      rails_endpoint_wrapper: [::WebController, :route],
    })
  end

  Kit::Router::Services::Adapters::Http::Rails::Routes.mount_http_targets(rails_router_context: self, list: list_web,)



  list_admin = []

  Kit::Router::Services::Adapters::Http::Rails::Routes.mount_http_targets(rails_router_context: self, list: list_admin,)


  # ----------------------------------------------------------------------------
  # Local to this app container

  list_local = [
    { id: 'app|home', path: '/', verb: :get },
  ]

  Kit::Router::Services::Adapters::Http::Rails::Routes.mount_rails_targets(rails_router_context: self, list: list_local,)

end
