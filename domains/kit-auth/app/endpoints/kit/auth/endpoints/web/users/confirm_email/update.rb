module Kit::Auth::Endpoints::Web::Users::ConfirmEmail::Update

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      ok:    [
        Kit::Auth::Actions::Applications::LoadWeb,
        Kit::Auth::Actions::Users::IdentifyUser,
        self.method(:load_user_email),
        self.method(:ensure_email_not_confirmed),
        Kit::Auth::Actions::Users::EnsureActiveToken,
        [:local_ctx, [:alias, :web_redirect_if_missing_scope!], { scope: Kit::Auth::Services::Scopes::USER_EMAIL_CONFIRMATION }],
        self.method(:confirm_email),
        self.method(:redirect),
      ],
      error: [
        self.method(:error_set_redirect),
        self.method(:error_token_revoked),
        self.method(:error_token_expired),
        Kit::Domain::Endpoints::Http.method(:redirect_with_errors),
      ],
      ctx:   { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|users|email|confirm',
    aliases: [
      'web|users|email|confirm',
    ],
    target:  self.method(:endpoint),
  )

  def self.load_user_email(access_token:)
    user_email_id = access_token.data['user_email_id']

    [:ok, user_email: Kit::Auth::Models::Write::UserEmail.find(user_email_id)]
  end

  def self.ensure_email_not_confirmed(router_conn:, user_email:)
    if user_email.confirmed?
      redirect_url = Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|home')

      Kit::Domain::Endpoints::Http.redirect_to(
        router_conn: router_conn,
        location:    redirect_url,
        flash:       {
          info: I18n.t('kit.auth.notifications.email_confirmation.errors.already_confirmed'),
        },
      )
    else
      [:ok]
    end
  end

  def self.confirm_email(router_conn:, user_email:, access_token:)
    status, ctx = Kit::Organizer.call(
      list: [
        Kit::Auth::Services::AccessToken.method(:revoke),
        Kit::Auth::Services::UserEmail.method(:confirm),
      ],
      ctx:  {
        router_conn:  router_conn,
        access_token: access_token,
        user_email:   user_email,
      },
    )

    [status, (status == :error) ? { errors: ctx[:errors] } : {}]
  end

  def self.redirect(router_conn:, redirect_url: nil)
    redirect_url ||= Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|home')

    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    redirect_url,
      flash:       {
        success: I18n.t('kit.auth.notifications.email_confirmation.success'),
      },
    )
  end

  # Error flow -----------------------------------------------------------------

  def self.error_set_redirect
    redirect_url = Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|home')

    [:ok, redirect_url: redirect_url]
  end

  def self.error_token_revoked(router_conn:, errors:)
    error_code = :oauth_token_revoked

    if Kit::Organizer.has_error_code?(code: error_code, errors: errors)
      error_text = I18n.t('kit.auth.notifications.email_confirmation.link.revoked')

      [:ok, errors: [{ detail: error_text, code: error_code }], overwrite_errors: true]
    else
      [:ok]
    end
  end

  def self.error_token_expired(router_conn:, errors:)
    error_code = :oauth_token_expired

    if Kit::Organizer.has_error_code?(code: error_code, errors: errors)
      error_text = I18n.t('kit.auth.notifications.email_confirmation.link.expired')

      [:ok, errors: [{ detail: error_text, code: error_code }], overwrite_errors: true]
    else
      [:ok]
    end
  end

end
