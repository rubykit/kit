module Kit::Auth::Services::Web::Routing

  def self.mount_routes_http_web(context:, rails_endpoint_wrapper:)
    list = [
      { route_id: 'web|authorization_tokens|new',            path: '/web/sign-in',                           verb: :get,    namespace: [:authorization] },
      { route_id: 'web|authorization_tokens|create',         path: '/web/sign-in',                           verb: :post,   namespace: [:authorization] },

      { route_id: 'web|users|sign_in_link_request|new',      path: '/web/sign-in/magic-link',                verb: :get,    namespace: [:authorization] },
      { route_id: 'web|users|sign_in_link_request|create',   path: '/web/sign-in/magic-link',                verb: :post,   namespace: [:authorization] },
      { route_id: 'web|authorization_tokens|email|create',   path: '/web/sign-in/use-magic-link',            verb: :get,    namespace: [:authorization] },

      { route_id: 'web|users|new',                           path: '/web/sign-up',                           verb: :get,    namespace: [:users] },
      { route_id: 'web|users|create',                        path: '/web/sign-up',                           verb: :post,   namespace: [:users] },

      { route_id: 'web|authorization_tokens|destroy',        path: '/web/sign-out',                          verb: :delete, namespace: [:authorization] },
      { route_id: 'web|settings|sessions|destroy',           path: '/web/settings/sessions/:user_secret_id', verb: :delete, namespace: [:oauth] },

      { route_id: 'web|settings|sessions|index',             path: '/web/settings/sessions',                 verb: :get,    namespace: [:authorization] },
      { route_id: 'web|settings|oauth|index',                path: '/web/settings/oauth',                    verb: :get,    namespace: [:authorization] },

      { route_id: 'web|users|email|confirm',                 path: '/web/settings/email/confirm',            verb: :get,    namespace: [:authorization] },

      { route_id: 'web|users|password_reset_request|new',    path: '/web/reset-password',                    verb: :get,    namespace: [:password] },
      { route_id: 'web|users|password_reset_request|create', path: '/web/reset-password',                    verb: :post,   namespace: [:password] },
      { route_id: 'web|users|password_reset|edit',           path: '/web/update-password',                   verb: :get,    namespace: [:password] },
      { route_id: 'web|users|password_reset|update',         path: '/web/update-password',                   verb: :put,    namespace: [:password] },
    ]

    list.each do |entry|
      entry.merge!({
        rails_endpoint_wrapper: rails_endpoint_wrapper,
        namespace:              [:kit_auth, :web].concat(entry[:namespace] || []),
      })
    end

    Kit::Router::Adapters::HttpRails::Routes.mount_http_targets(rails_router_context: context, list: list)

    mount_routes_http_web_oauth(context: context, rails_endpoint_wrapper: rails_endpoint_wrapper)
  end

  # Add Oauth routes with specific `request_config`.
  def self.mount_routes_http_web_oauth(context:, rails_endpoint_wrapper:)
    list = [
      #{ route_id: 'web|users|oauth|authentify',      path: '/web/oauth/authentify/:provider',             verb: :get,    namespace: [:oauth] },
      { route_id: 'web|users|oauth|callback',        path: '/web/oauth/callback/:provider',               verb: :get,    namespace: [:oauth] },

      { route_id: 'web|users|oauth|sign_up',         path: '/web/oauth/sign-up/:provider',                verb: :get,    namespace: [:oauth], request_config: { intent_type: :user_sign_up } },
      { route_id: 'web|users|oauth|sign_in',         path: '/web/oauth/sign-in/:provider',                verb: :get,    namespace: [:oauth], request_config: { intent_type: :user_sign_in } },

      { route_id: 'web|settings|oauth|destroy', path: '/web/settings/oauth/:user_oauth_identity_id', verb: :delete, namespace: [:oauth] },
    ]

    list.each do |entry|
      entry = entry.merge({
        rails_router_context:   context,
        rails_endpoint_wrapper: rails_endpoint_wrapper,
        namespace:              [:kit_auth, :web].concat(entry[:namespace] || []),
      })

      Kit::Router::Adapters::HttpRails::Routes.mount_http_target(**entry)
    end
  end

end
