module Kit::Auth::Endpoints::Web::Users::PasswordResetRequest::Create

  # Create a PasswordResetRequest for a given email
  def self.endpoint(router_conn:, component: nil)
    Kit::Organizer.call(
      ok:    [
        [:alias, :web_redirect_if_session_user!],
        self.method(:set_form_model),
        self.method(:create_password_reset_request),
        self.method(:set_i18n_params),
        self.method(:redirect),
      ],
      error: [
        Kit::Auth::Endpoints::Web::Users::PasswordResetRequest::New.method(:set_page_component),
        Kit::Domain::Endpoints::Http.method(:render_form_page),
      ],
      ctx:   {
        router_conn: router_conn,
        component:   component,
      },
    )
  end

  def self.register_endpoint
    Kit::Router::Services::Router.register(
      uid:     'kit_auth|web|users|password_reset|request|create',
      aliases: ['web|users|password_reset|request|create'],
      target:  self.method(:endpoint),
    )
  end

  def self.set_form_model(router_conn:)
    form_model = router_conn.request[:params].slice(:email)

    [:ok, form_model: form_model]
  end

  def self.create_password_reset_request(router_conn:, form_model:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::Users::RequestPasswordReset,
      ],
      ctx:  {
        router_conn: router_conn,
        email:       form_model[:email],
      },
    )
  end

  def self.set_i18n_params(router_conn:, form_model:)
    [:ok, i18n_params: {
      email: form_model[:email],
    },]
  end

  def self.redirect(router_conn:, form_model:, redirect_url: nil, i18n_params: nil)
    redirect_url ||= Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|password_reset_request|after')

    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    redirect_url,
      flash:       {
        notice: I18n.t('kit.auth.notifications.password_reset_request.success', **(i18n_params || {})),
      },
    )
  end

end
