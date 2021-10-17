module Kit::Auth::Services::Web::Routing

  def self.mount_routes_http_web(context:, rails_endpoint_wrapper:)
    list_web = [
      { route_id: 'web|authorization_tokens|new',            path: '/web/sign-in',                           verb: :get,    namespace: [:authorization] },
      { route_id: 'web|authorization_tokens|create',         path: '/web/sign-in',                           verb: :post,   namespace: [:authorization] },

      { route_id: 'web|users|sign_in_link_request|new',      path: '/web/sign-in/magic-link',                verb: :get,    namespace: [:authorization] },
      { route_id: 'web|users|sign_in_link_request|create',   path: '/web/sign-in/magic-link',                verb: :post,   namespace: [:authorization] },
      { route_id: 'web|authorization_tokens|email|create',   path: '/web/sign-in/use-magic-link',            verb: :get,    namespace: [:authorization] },

      { route_id: 'web|users|new',                           path: '/web/sign-up',                           verb: :get,    namespace: [:users] },
      { route_id: 'web|users|create',                        path: '/web/sign-up',                           verb: :post,   namespace: [:users] },

      { route_id: 'web|authorization_tokens|destroy',        path: '/web/sign-out',                          verb: :delete, namespace: [:authorization] },

      { route_id: 'web|authorization_tokens|index',          path: '/web/settings/devices',                  verb: :get,    namespace: [:authorization] },

      { route_id: 'web|users|email|confirm',                 path: '/web/settings/email/confirm',            verb: :get,    namespace: [:authorization] },

      { route_id: 'web|users|password_reset_request|new',    path: '/web/reset-password',                    verb: :get,    namespace: [:password] },
      { route_id: 'web|users|password_reset_request|create', path: '/web/reset-password',                    verb: :post,   namespace: [:password] },
      { route_id: 'web|users|password_reset|edit',           path: '/web/update-password',                   verb: :get,    namespace: [:password] },
      { route_id: 'web|users|password_reset|update',         path: '/web/update-password',                   verb: :put,    namespace: [:password] },
    ]

    list_web.each do |entry|
      entry.merge!({
        rails_endpoint_wrapper: [rails_endpoint_wrapper, :route],
        namespace:              [:kit_auth, :web].concat(entry[:namespace] || []),
      })
    end

    Kit::Router::Adapters::HttpRails::Routes.mount_http_targets(rails_router_context: context, list: list_web)
  end

end
