module Kit::Auth::DummyApp::Services::Routing

  def self.mount_routes_http_rails(context:)
    list = [
      { route_id: 'web|rails_example', path: '/web/dummy_app/rails_example', verb: :get },
    ]

    Kit::Router::Adapters::HttpRails::Routes.mount_rails_targets(rails_router_context: context, list: list)
  end

  def self.mount_routes_http_web(context:, rails_endpoint_wrapper:)
    list = [
      { route_id: 'web|home',                 path: '/',                         verb: :get },
      { route_id: 'web|settings',             path: '/web/settings',             verb: :get },
    ]

    Kit::Router::Adapters::HttpRails::Routes.mount_http_targets(
      rails_router_context:   context,
      rails_endpoint_wrapper: rails_endpoint_wrapper,
      namespace:              [:kit_auth, :dummy_app, :web],
      list:                   list,
    )

    [:ok]
  end

  # Override the default aliases to test redirect in specs.
  #
  # Note: if you're using this, you probably want to have a look at `Kit::Auth::DummyApp::Endpoints::Web::RouteAlias.endpoint` too.
  def self.mount_routes_http_web_aliases(context:, rails_endpoint_wrapper:, routes_ids: nil)
    route_ids ||= Kit::Auth::DummyApp::Endpoints::Web::RouteAlias::ALIASES

    list = route_ids.map do |route_id|
      { route_id: route_id, path: "/web/dummy-app/route-alias/#{ route_id.gsub('|', '__') }", verb: :get }
    end

    Kit::Router::Adapters::HttpRails::Routes.mount_http_targets(
      rails_router_context:   context,
      rails_endpoint_wrapper: rails_endpoint_wrapper,
      namespace:              [:kit_auth, :dummy_app, :web, :aliases],
      list:                   list,
    )

    [:ok]
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
          namespace: [:api, :json_api, namespace],
        })
      end

      Kit::Router::Adapters::HttpRails::Routes.mount_http_targets(
        rails_endpoint_wrapper: rails_endpoint_wrapper,
        rails_router_context:   context,
        list:                   mountpoints,
        request_config:         {
          api: DUMMY_APP_API_CONFIG,
        },
      )
    end
  end

end
