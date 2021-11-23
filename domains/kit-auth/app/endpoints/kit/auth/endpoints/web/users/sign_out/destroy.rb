module Kit::Auth::Endpoints::Web::Users::SignOut::Destroy

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::Applications::LoadWeb,
        Kit::Auth::Actions::Users::IdentifyUserForConn,
        [:alias, :web_require_session_user!],
        ->(router_conn:) { [:ok, access_token: router_conn.metadata[:session_user_access_token]] },
        Kit::Auth::Actions::Users::RevokeAccessToken,
        Kit::Auth::Actions::Users::SignOutWeb,
        self.method(:redirect),
      ],
      ctx:  {
        router_conn: router_conn,
      },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|authorization_tokens|destroy',
    aliases: {
      'web|authorization_tokens|destroy': ['web|users|sign_out'],
    },
    target:  self.method(:endpoint),
  )

  def self.redirect(router_conn:, redirect_url: nil)
    redirect_url ||= Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|sign_out|after')

    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    redirect_url,
      flash:       {
        info: I18n.t('kit.auth.notifications.sign_out.success'),
      },
    )
  end

end
