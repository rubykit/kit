module Kit::Auth::Endpoints::Web::Users::SignOut::Destroy

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        [:alias, :web_require_current_user!],
        self.method(:set_access_token),
        self.method(:clear_cookies),
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

  def self.set_access_token(router_conn:)
    [:ok, access_token: router_conn.metadata[:current_user_access_token]]
  end

  def self.clear_cookies(router_conn:)
    router_conn.response[:http][:cookies][:access_token] = { value: nil, encrypted: true }

    [:ok, router_conn: router_conn]
  end

  def self.redirect(router_conn:, redirect_url: nil)
    redirect_url ||= Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|sign_out|after')

    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    redirect_url,
      flash:       {
        success: I18n.t('kit.auth.notifications.sign_out.success'),
      },
    )
  end

end
