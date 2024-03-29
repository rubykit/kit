module Kit::Auth::Endpoints::Web::Users::Settings::Sessions::Destroy

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::Applications::LoadWeb,
        Kit::Auth::Actions::Users::IdentifyUserForConn,
        [:alias, :web_require_session_user!],
        self.method(:load_user_secret),
        [:local_ctx, Kit::Domain::Endpoints::Http::Web.method(:require_belongs_to!), nil, { parent: :session_user, child: :user_secret }],
        Kit::Auth::Actions::Users::RevokeAccessToken,
        self.method(:redirect),
      ],
      ctx:  {
        router_conn: router_conn,
      },
    )
  end

  def self.register_endpoint
    Kit::Router::Services::Router.register(
      uid:     'kit_auth|web|settings|sessions|destroy',
      aliases: {
        'web|settings|sessions|destroy' => {
          'web|users|access_token|revoke'       => [],
          'web|settings|sessions|destroy|after' => [
            'web|users|access_token|revoke|after',
          ],
        },
      },
      target:  self.method(:endpoint),
    )
  end

  def self.load_user_secret(router_conn:)
    model_id = router_conn[:params][:user_secret_id]
    model    = Kit::Auth::Models::Read::UserSecret.find_by(id: model_id)

    [:ok, user_secret: model, access_token: model]
  end

  def self.redirect(router_conn:, redirect_url: nil, i18n_params: nil)
    redirect_url ||= Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|settings|sessions|destroy|after')
    i18n_params  ||= {}

    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    redirect_url,
      flash:       {
        info: I18n.t('kit.auth.notifications.sign_out.devices.success', **i18n_params),
      },
    )
  end

end
