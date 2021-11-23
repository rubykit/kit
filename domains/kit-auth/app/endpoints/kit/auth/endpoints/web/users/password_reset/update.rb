module Kit::Auth::Endpoints::Web::Users::PasswordReset::Update

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      ok:    [
        Kit::Auth::Actions::Applications::LoadWeb,
        Kit::Auth::Actions::Users::IdentifyUserForConn,
        ->(router_conn:) { [:ok, access_token: router_conn.metadata[:request_user_access_token]] },
        Kit::Auth::Actions::Users::EnsureActiveToken,
        [:local_ctx, [:alias, :web_redirect_if_missing_scope!], { scope: Kit::Auth::Services::Scopes::USER_PASSWORD_UPDATE }],
        self.method(:set_form_model),
        self.method(:update_password),
        self.method(:redirect),
      ],
      error: [
        Kit::Auth::Endpoints::Web::Users::PasswordReset::Edit.method(:handle_error_token_revoked),
        Kit::Auth::Endpoints::Web::Users::PasswordReset::Edit.method(:handle_error_token_expired),
        Kit::Domain::Endpoints::Http.method(:attempt_redirect_with_errors),
        Kit::Auth::Endpoints::Web::Users::PasswordReset::Edit.method(:set_page_component),
        Kit::Auth::Endpoints::Web::Users::PasswordReset::Edit.method(:render_form_page),
      ],
      ctx:   { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|users|password_reset|update',
    aliases: ['web|users|password_reset|update'],
    target:  self.method(:endpoint),
  )

  def self.set_form_model(router_conn:)
    form_model = router_conn.request[:params].slice(:password, :password_confirmation)

    [:ok, form_model: form_model]
  end

  def self.update_password(router_conn:, form_model:, access_token:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::Users::UpdatePassword,
        Kit::Auth::Services::AccessToken.method(:revoke),
        Kit::Auth::Actions::Users::SignInWeb,
      ],
      ctx:  {
        router_conn:    router_conn,
        user:           access_token.user,
        access_token:   access_token,
        sign_in_method: :password,
      }.merge(form_model),
    )
  end

  def self.redirect(router_conn:, i18n_params: nil)
    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|password_reset|after'),
      flash:       {
        success: I18n.t('kit.auth.notifications.password_reset.success', **(i18n_params || {})),
      },
    )
  end

end
