module Kit::Auth::DummyApp::Endpoints::Web::Home

  def self.endpoint(router_conn:)
    status, ctx = Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|settings|sessions|index'),
    )

    [:ok, ctx]
  end

  Kit::Router::Services::Router.register(
    uid:     'kit-auth|dummy_app|web|home',
    aliases: {
      'web|home': {
        'web|home|signed_in': [

          # OAuth
          'web|users|oauth|sign_in|after',
          'web|users|oauth|sign_up|after',
        ],
        'web|home|signed_out': [],
      }
    },
    target:  self.method(:endpoint),
  )

  def self.render(router_conn:)
    Kit::Domain::Endpoints::Http.render(
      router_conn: router_conn,
      component:   Kit::Auth::DummyApp::Components::Pages::HomeComponent,
    )
  end

end
