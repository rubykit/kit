module Kit::Auth::DummyApp::Endpoints::Web::Home

  def self.endpoint(router_conn:)
    Kit::Domain::Endpoints::Http.render(
      router_conn: router_conn,
      component:   Kit::Auth::DummyApp::Components::Pages::HomeComponent,
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit-auth|dummy_app|web|home',
    aliases: {
      'web|home': {
        'web|home|signed_in': [
          'web|users|sign_in|after',
          'web|users|sign_up|after',
          'web|users|password_reset|after',

          'web|users|email_confirmation|after|signed_in',
          'web|users|email_confirmation|after|signed_out',

          # OAuth
          'web|users|oauth|sign_in|after',
          'web|users|oauth|sign_up|after',

          # Errors
          'web|errors|forbidden',
          'web|errors|missing_scope',
        ],
        'web|home|signed_out': [
          'web|users|sign_out|after',
        ],
      }
    },
    target:  self.method(:endpoint),
  )

end
