module Kit::Auth::Endpoints::Web::Users::SignIn::WithPassword::Create

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      ok:    [
        [:alias, :web_redirect_if_current_user!],
        self.method(:set_form_model),
        self.method(:create_sign_in),
        self.method(:redirect),
      ],
      error: [
        Kit::Auth::Endpoints::Web::Users::SignIn::WithPassword::New.method(:set_page_component),
        Kit::Router::Controllers::Http.method(:render_form_page),
      ],
      ctx:   { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|authorization_tokens|create',
    aliases: [
      'web|authorization_tokens|create',
    ],
    target:  self.method(:endpoint),
  )

  def self.set_form_model(router_conn:)
    attributes = [:email, :password]
    form_model = router_conn.request[:params].slice(*attributes)

    [:ok, form_model: form_model]
  end

  def self.create_sign_in(router_conn:, form_model:)
    Kit::Organizer.call(
      ok:  [
        ->(email:) { [:ok, user: Kit::Auth::Models::Read::User.find_by(email: email)] },
        Kit::Auth::Actions::Users::VerifyPassword,
        Kit::Auth::Actions::Users::SignInWeb,
      ],
      ctx: {
        router_conn: router_conn,
      }.merge(form_model),
    )
  end

  def self.redirect(router_conn:, redirect_url: nil)
    redirect_url ||= Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|sign_in|after')

    Kit::Router::Controllers::Http.redirect_to(
      router_conn: router_conn,
      location:    redirect_url,
      flash:       {
        success: I18n.t('kit.auth.notifications.sign_in.success'),
      },
    )
  end

end
