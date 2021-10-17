module Kit::Auth::DummyApp::Services::Routing

  def self.mount_routes_http_web(context:, rails_endpoint_wrapper:)
    list_web = [
      { route_id: 'web|intent|post_sign_in', path: '/web/intent-sign-in', verb: :get },
      { route_id: 'web|intent|post_sign_up', path: '/web/intent-sign-up', verb: :get },
    ]

    list_web.each do |entry|
      entry.merge!({
        rails_endpoint_wrapper: [rails_endpoint_wrapper, :route],
        namespace:              [:kit_auth, :dummy_app, :web].concat(entry[:namespace] || []),
      })
    end

    Kit::Router::Adapters::HttpRails::Routes.mount_http_targets(rails_router_context: context, list: list_web)
  end


  def self.mount_routes_http_api_jsonapi(context:, rails_endpoint_wrapper:)
    endpoints = ->(resource_singular:, resource_plural:) do
      [
        { route_id: "api|json_api|#{ resource_singular }|index",  path: "/json_api/#{ resource_plural }",              verb: :get    },
        { route_id: "api|json_api|#{ resource_singular }|show",   path: "/json_api/#{ resource_plural }/:resource_id", verb: :get    },
        #{ route_id: "api|#{ resource_singular }|create", path: "/json_api/#{ resource_plural }",              verb: :post   },
        #{ route_id: "api|#{ resource_singular }|update", path: "/json_api/#{ resource_plural }/:resource_id", verb: :patch  },
        #{ route_id: "api|#{ resource_singular }|delete", path: "/json_api/#{ resource_plural }/:resource_id", verb: :delete },
      ]
    end

    list_api = {
      user_auths:  :user_auth,
      user_emails: :user_email,
    }

    list_api.each do |k, v|
      list_api[k] = endpoints.call(resource_plural: k, resource_singular: v)
    end

    list_api.each do |namespace, mountpoints|
      mountpoints.each do |mountpoint|
        mountpoint.merge!({
          rails_endpoint_wrapper: [rails_endpoint_wrapper, :route],
          namespace:              [:api, :json_api, namespace],
        })
      end

      Kit::Router::Adapters::HttpRails::Routes.mount_http_targets(
        rails_router_context: context,
        list:                 mountpoints,
        request_config:       {
          api: DUMMY_APP_API_CONFIG,
        },
      )
    end
  end


end
