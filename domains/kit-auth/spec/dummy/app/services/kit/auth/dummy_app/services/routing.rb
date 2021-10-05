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

end
