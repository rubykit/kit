module Kit::Auth::Endpoints::Web::Users::PasswordReset::Edit

  def self.endpoint(router_conn:, component: nil)
    Kit::Organizer.call(
      ok:    [
        Kit::Auth::Actions::Applications::LoadWeb,
        Kit::Auth::Actions::Users::IdentifyUserForConn,
        ->(router_conn:) { [:ok, access_token: router_conn.metadata[:request_user_access_token]] },
        Kit::Auth::Actions::Users::EnsureActiveToken,
        [:local_ctx, [:alias, :web_redirect_if_request_missing_scope!], { scope: Kit::Auth::Services::Scopes::USER_PASSWORD_UPDATE }],
        self.method(:set_form_model),
        self.method(:set_page_component),
        self.method(:render_form_page),
      ],
      error: [
        self.method(:handle_error_token_revoked),
        self.method(:handle_error_token_expired),
        Kit::Domain::Endpoints::Http.method(:attempt_redirect_with_errors),
      ],
      ctx:   {
        router_conn: router_conn,
        component:   component,
      },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|users|password_reset|edit',
    aliases: ['web|users|password_reset|edit'],
    target:  self.method(:endpoint),
  )

  def self.set_form_model
    form_model = { password: nil, password_confirmation: nil }

    [:ok, form_model: form_model]
  end

  def self.set_page_component(component: nil)
    [:ok, component: component || Kit::Auth::Components::Pages::Users::PasswordReset::EditComponent]
  end

  def self.render_form_page(router_conn:, form_model:, component:, errors: nil)
    Kit::Domain::Endpoints::Http.render(
      router_conn: router_conn,
      component:   component,
      params:      {
        access_token: router_conn.request[:params][:access_token],
        csrf_token:   router_conn.request[:http][:csrf_token],
        errors_list:  errors,
        model:        form_model,
      },
    )
  end

  # Error flow -----------------------------------------------------------------

  def self.handle_error_token_revoked(router_conn:, errors:)
    error_code = :oauth_token_revoked

    if Kit::Organizer.has_error_code?(code: error_code, errors: errors)
      error_text   = I18n.t('kit.auth.notifications.password_reset.link.revoked')
      redirect_url = Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|password_reset|request|new')

      [:ok, {
        errors:           [{ detail: error_text, code: error_code }],
        overwrite_errors: true,
        redirect_url:     redirect_url,
      },]
    else
      [:ok]
    end
  end

  def self.handle_error_token_expired(router_conn:, errors:)
    error_code = :oauth_token_expired

    if Kit::Organizer.has_error_code?(code: error_code, errors: errors)
      error_text   = I18n.t('kit.auth.notifications.password_reset.link.expired')
      redirect_url = Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|password_reset|request|new')

      [:ok, {
        errors:           [{ detail: error_text, code: error_code }],
        overwrite_errors: true,
        redirect_url:     redirect_url,
      },]
    else
      [:ok]
    end
  end

end
