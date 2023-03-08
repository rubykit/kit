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

  ALIASES = [
    'web|users|sign_in|after',
    'web|users|sign_up|after',
    'web|users|sign_out|after',

    'web|users|password_reset|after',
    'web|users|password_reset_request|after',

    'web|users|email_confirmation|after|signed_in',
    'web|users|email_confirmation|after|signed_out',

    # Oauth
    'web|users|sign_in|oauth|after',
    'web|users|sign_up|oauth|after',
    'web|users|sign_in|oauth|after_with_new_identity',

    'web|users|oauth|new_identity',
    'web|users|oauth|error|already_linked',
    'web|users|oauth|error|users_oauth_identity_conflict',
    'web|users|oauth|error|users_conflict',

    # Settings
    'web|settings|sessions|destroy|after',
    'web|settings|oauth|destroy|after',

    # Specs intent routes (specifically for specs)
    'web|intent|post_sign_in',
    'web|intent|post_sign_up',

    # Errors
    'web|errors|forbidden',
    'web|errors|missing_scope',
  ]

  def self.register_endpoint
    return if !Rails.env.test?

    Kit::Router::Services::Router.register(
      uid:     'kit-auth|dummy_app|web|route_alias',
      aliases: {
        'dummy_app|web|route_alias' => ALIASES,
      },
      target:  self.method(:endpoint),
    )
  end

end
