# To avoid "magic" in specs, we use these endpoint to set cookies when needed.
module Kit::Domain::Endpoints::Specs::Cookies

  def self.endpoint_get(router_conn:)
    cookie_name      = router_conn[:params][:name]&.to_sym
    cookie_encrypted = router_conn[:params][:encrypted] == 'true'
    cookie_value     = router_conn.request[:http][:cookies][cookie_name]&.dig(:value)

    response = router_conn[:response]

    response[:content]       = "#{ cookie_name }\n#{ cookie_value }"
    response[:http][:status] = 200
    response[:http][:mime]   = :text

    [:ok, { router_conn: router_conn }]
  end

  Kit::Router::Services::Router.register(
    uid:     'kit-domain|specs|cookies|get',
    aliases: ['specs|cookies|get'],
    target:  self.method(:endpoint_get),
  )

  def self.endpoint_set(router_conn:)
    cookie_name      = router_conn[:params][:name]&.to_sym
    cookie_value     = router_conn[:params][:value]
    cookie_encrypted = router_conn[:params][:encrypted] == 'true'

    if cookie_name
      router_conn.response[:http][:cookies][cookie_name] = { value: cookie_value, encrypted: cookie_encrypted }
    end

    status, ctx = Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    Kit::Router::Adapters::Http::Mountpoints.path(id: 'specs|cookies|get', params: { name: cookie_name, encrypted: cookie_encrypted }),
    )

    [:ok, ctx]
  end

  Kit::Router::Services::Router.register(
    uid:     'kit-domain|specs|cookies|set',
    aliases: ['specs|cookies|set'],
    target:  self.method(:endpoint_set),
  )

end
