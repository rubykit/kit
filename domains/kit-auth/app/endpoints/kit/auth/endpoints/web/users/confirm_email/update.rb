module Kit::Auth::Endpoints::Web::Users::ConfirmEmail::Update

  def self.register_endpoint
    Kit::Router::Services::Router.register(
      uid:     'kit_auth|web|users|email|confirm',
      aliases: [
        'web|users|email|confirm',
      ],
      target:  self.method(:endpoint),
    )
  end

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      ok:    [
        Kit::Auth::Actions::Applications::LoadWeb,
        Kit::Auth::Actions::Users::IdentifyUserForConn,
        ->(router_conn:) { [:ok, access_token: router_conn.metadata[:request_user_access_token]] },
        Kit::Auth::Actions::Users::ConfirmEmail,
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

  def self.redirect(router_conn:, redirect_url: nil)
    if !redirect_url
      if router_conn.metadata[:session_user_access_token]&.active?
        route_id = 'web|users|email_confirmation|after|signed_in'
      else
        route_id = 'web|users|email_confirmation|after|signed_out'
      end

      redirect_url = Kit::Router::Adapters::Http::Mountpoints.path(id: route_id)
    end

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
