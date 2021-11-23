module Kit::Domain::Services::Specs::Routing

  def self.mount_routes_http_web(context:, rails_endpoint_wrapper:)
    list = [
      { route_id: 'specs|cookies|set', path: '/specs_helpers/cookies/set', verb: :get },
      { route_id: 'specs|cookies|get', path: '/specs_helpers/cookies/get', verb: :get },

      { route_id: 'specs|link_to',     path: '/specs_helpers/link_to',     verb: :get },
    ]

    Kit::Router::Adapters::HttpRails::Routes.mount_http_targets(
      rails_router_context:   context,
      rails_endpoint_wrapper: rails_endpoint_wrapper,
      namespace:              [:kit_domain, :specs, :web],
      list:                   list,
    )

    [:ok]
  end

end
