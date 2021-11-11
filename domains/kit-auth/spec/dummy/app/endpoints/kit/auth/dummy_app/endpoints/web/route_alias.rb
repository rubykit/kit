module Kit::Auth::DummyApp::Endpoints::Web::RouteAlias

  # Spec endpoint to test aliasing & redirect.
  #
  # Note: if you're using this you probably want to have a look at `Kit::Auth::DummyApp::Services::Routing.mount_routes_http_web_aliases` too.
  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      ok:  [
        Kit::Domain::Endpoints::Http.method(:render),
      ],
      ctx: {
        router_conn: router_conn,
        component:   Kit::Auth::DummyApp::Components::Pages::RouteAliasComponent,
      },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit-auth|dummy_app|web|route_alias',
    aliases: {
      'dummy_app|web|route_alias' => [
        'web|users|sign_in|after',
        'web|users|sign_up|after',
        'web|users|sign_out|after',

        'web|users|password_reset|after',
        'web|users|password_reset_request|after',

        'web|users|email_confirmation|after|signed_in',
        'web|users|email_confirmation|after|signed_out',

        # Specs intent routes (specifically for specs)
        'web|intent|post_sign_in',
        'web|intent|post_sign_up',
      ],
    },
    target:  self.method(:endpoint),
  )

end
