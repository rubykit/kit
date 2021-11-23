module Kit::Auth::DummyApp::Endpoints::Web::Settings

  def self.endpoint(router_conn:)
    status, ctx = Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|settings|sessions'),
    )

    [:ok, ctx]
  end

  Kit::Router::Services::Router.register(
    uid:     'kit-auth|dummy_app|web|settings',
    aliases: ['web|settings'],
    target:  self.method(:endpoint),
  )

end
