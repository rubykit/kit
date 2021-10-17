module Kit::Auth::Services::Api::Routing

  def self.mount_routes_http_web(context:, rails_endpoint_wrapper:)
    list_web = [
      { route_id: 'web|authorization_tokens|new',    path: '/web/sign-in', verb: :get,  namespace: [:authorization] },
      { route_id: 'web|authorization_tokens|create', path: '/web/sign-in', verb: :post, namespace: [:authorization] },
    ]

    list_web.each do |entry|
      entry.merge!({
        rails_endpoint_wrapper: [rails_endpoint_wrapper, :route],
        namespace:              [:kit_auth, :api].concat(entry[:namespace] || []),
      })
    end

    Kit::Router::Adapters::HttpRails::Routes.mount_http_targets(rails_router_context: context, list: list_web)
  end

end
