module Kit::Auth::Endpoints::Web::Users::SignIn::WithMagicLink::Create

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      ok:    [
        Kit::Auth::Actions::OauthApplications::LoadWeb,
        Kit::Auth::Actions::Users::IdentifyUser,
        Kit::Auth::Actions::Users::EnsureActiveToken,
        [:local_ctx, [:alias, :web_redirect_if_missing_scope!], { scope: :one_time_sign_in }],
        self.method(:create_sign_in),
        Kit::Auth::Endpoints::Web::Users::SignIn::WithPassword::Create.method(:redirect),
      ],
      error: [
        self.method(:handle_error_token_revoked),
        self.method(:handle_error_token_expired),
        self.method(:handle_error),
      ],
      ctx:   { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|authorization_tokens|email|create',
    aliases: [
      'web|authorization_tokens|email|create',
    ],
    target:  self.method(:endpoint),
  )

  def self.create_sign_in(router_conn:, oauth_access_token:)
    status, ctx = Kit::Organizer.call(
      list: [
        Kit::Auth::Services::OauthAccessToken.method(:revoke),
        Kit::Auth::Actions::Users::SignInWeb,
      ],
      ctx:  {
        router_conn:        router_conn,
        oauth_access_token: oauth_access_token,
        user:               oauth_access_token.user,
      },
    )

    [status, (status == :error) ? { errors: ctx[:errors] } : {}]
  end

  # Error flow -----------------------------------------------------------------

  def self.handle_error_token_revoked(router_conn:, errors:)
    error_code = :oauth_token_revoked

    if Kit::Organizer.has_error_code?(code: error_code, errors: errors)
      error_text   = I18n.t('kit.auth.notifications.sign_in.link.revoked')
      redirect_url = Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|sign_in_link_request|new')

      [:ok, errors: [{ detail: error_text, code: error_code }], overwrite_errors: true, redirect_url: redirect_url]
    else
      [:ok]
    end
  end

  def self.handle_error_token_expired(router_conn:, errors:)
    error_code = :oauth_token_expired

    if Kit::Organizer.has_error_code?(code: error_code, errors: errors)
      error_text   = I18n.t('kit.auth.notifications.sign_in.link.expired')
      redirect_url = Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|sign_in_link_request|new')

      [:ok, errors: [{ detail: error_text, code: error_code }], overwrite_errors: true, redirect_url: redirect_url]
    else
      [:ok]
    end
  end

  def self.handle_error(router_conn:, redirect_url:, errors: nil)
    if !redirect_url
      redirect_url = Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|sign_in')
    end

    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    redirect_url,
      flash:       {
        error: errors.map { |el| el[:detail] }.join('<br>'),
      },
    )
  end

end
