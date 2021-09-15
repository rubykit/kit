module Kit::Auth::Endpoints::Web::Users::SignOut::Destroy

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        [:alias, :web_require_current_user!],
        self.method(:sign_out),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|authorization_tokens|destroy',
    aliases: {
      'web|authorization_tokens|destroy': ['web|users|sign_out'],
    },
    target:  self.method(:endpoint),
  )

  def self.sign_out(router_conn:)
    access_token = router_conn.metadata[:current_user_oauth_access_token]
    if access_token
      Kit::Auth::Services::OauthAccessToken.revoke(oauth_access_token: access_token)

      router_conn.response[:http][:cookies][:access_token] = { value: nil, encrypted: true }
    end

    Kit::Router::Controllers::Http.redirect_to(
      router_conn: router_conn,
      location:    Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|sign_out|after'),
    )
  end

end
