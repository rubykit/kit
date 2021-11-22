module Kit::Auth::Endpoints::Web::Users::Settings::Oauth::Destroy

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::Applications::LoadWeb,
        Kit::Auth::Actions::Users::IdentifyUserForConn,
        [:alias, :web_require_session_user!],
        self.method(:load_oauth_user_identity),
        [:local_ctx, Kit::Domain::Endpoints::Http::Web.method(:require_belongs_to!), nil, { parent: :session_user, child: :user_oauth_identity }],
        Kit::Auth::Actions::Oauth::UnlinkIdentity,
        self.method(:redirect),
      ],
      ctx:  {
        router_conn: router_conn,
      },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|settings|oauth|destroy',
    aliases: {
      'web|settings|oauth|destroy' => {
        'web|user_oauth_identity|destroy'  => [],
        'web|settings|oauth|destroy|after' => [
          'web|user_oauth_identity|destroy|after',
        ],
      },
    },
    target:  self.method(:endpoint),
  )

  def self.load_oauth_user_identity(router_conn:)
    model_id = router_conn[:params][:user_oauth_identity_id]
    model    = Kit::Auth::Models::Read::UserOauthIdentity.find_by(id: model_id)

    [:ok, user_oauth_identity: model]
  end

  def self.redirect(router_conn:, user_oauth_identity:, redirect_url: nil, i18n_params: nil)
    redirect_url ||= Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|settings|oauth|destroy|after')

    i18n_params = {
      provider: user_oauth_identity.provider,
    }.merge(i18n_params || {})

    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    redirect_url,
      flash:       {
        info: I18n.t('kit.auth.notifications.oauth.unlink.success', **i18n_params),
      },
    )
  end

end
