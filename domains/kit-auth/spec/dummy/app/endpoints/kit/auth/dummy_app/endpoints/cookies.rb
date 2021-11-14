# To avoid "magic" in specs, we use these endpoint to set cookies when needed.
module Kit::Auth::DummyApp::Endpoints::Cookies

  def self.endpoint_get(router_conn:)
    cookie_name      = router_conn[:params][:cookie_name]&.to_sym
    cookie_encrypted = router_conn[:params][:cookie_encrypted] == 'true'
    cookie_value     = router_conn.request[:http][:cookies][cookie_name]&.dig(:value)

    response = router_conn[:response]

    response[:content]       = "#{ cookie_name }\n#{ cookie_value }"
    response[:http][:status] = 200
    response[:http][:mime]   = :text

    [:ok, { router_conn: router_conn }]
  end

  Kit::Router::Services::Router.register(
    uid:     'kit-auth|dummy_app|cookies|get',
    aliases: ['dummy_app|cookies|get'],
    target:  self.method(:endpoint_get),
  )

  def self.endpoint_set(router_conn:)
    cookie_name      = router_conn[:params][:cookie_name]&.to_sym
    cookie_value     = router_conn[:params][:cookie_value]
    cookie_encrypted = router_conn[:params][:cookie_encrypted] == 'true'

    if cookie_name
      router_conn.response[:http][:cookies][cookie_name] = { value: cookie_value, encrypted: cookie_encrypted }
    end

    status, ctx = Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    Kit::Router::Adapters::Http::Mountpoints.path(id: 'dummy_app|cookies|get', params: { cookie_name: cookie_name, cookie_encrypted: cookie_encrypted }),
    )

    [:ok, ctx]
  end

  Kit::Router::Services::Router.register(
    uid:     'kit-auth|dummy_app|cookies|set',
    aliases: ['dummy_app|cookies|set'],
    target:  self.method(:endpoint_set),
  )

end
