module Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::Create

  def self.endpoint(router_conn:, component: nil)
    Kit::Organizer.call(
      ok:    [
        [:alias, :web_redirect_if_session_user!],
        self.method(:set_form_model),
        self.method(:create_user),

        [:local_ctx, Kit::Router::Adapters::Http::Intent::Actions::Consume, { intent_step: :user_sign_up }],
        self.method(:redirect),
      ],
      error: [
        self.method(:attempt_sign_in_on_error),
        Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::New.method(:set_page_component),
        Kit::Domain::Endpoints::Http.method(:render_form_page),
      ],
      ctx:   {
        router_conn: router_conn,
        component:   component,
      },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|users|create',
    aliases: [
      'web|users|create',
    ],
    target:  self.method(:endpoint),
  )

  def self.set_form_model(router_conn:)
    attributes = [:email, :password, :password_confirmation]
    form_model = router_conn.request[:params].slice(*attributes)

    [:ok, form_model: form_model]
  end

  def self.create_user(router_conn:, form_model:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::Users::CreateWithPassword,
        Kit::Auth::Actions::Users::SignInWeb,
      ],
      ctx:  {
        router_conn:    router_conn,
        sign_in_method: :password,
      }.merge(form_model),
    )
  end

  def self.redirect(router_conn:, redirect_url: nil)
    redirect_url ||= Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|sign_up|after')

    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    redirect_url,
      flash:       {
        success: I18n.t('kit.auth.notifications.sign_up.success'),
      },
    )
  end

  # Error flow -----------------------------------------------------------------

  def self.attempt_sign_in_on_error(router_conn:, form_model:)
    status, ctx = Kit::Organizer.call(
      ok:  [
        Kit::Auth::Endpoints::Web::Users::SignIn::WithPassword::Create.method(:create_sign_in),
        Kit::Auth::Endpoints::Web::Users::SignIn::WithPassword::Create.method(:redirect),
      ],
      ctx: {
        router_conn: router_conn,
        form_model:  form_model,
      },
    )

    if status == :ok
      [:halt, ctx]
    else
      # Continue in the error handling flow
      [:ok]
    end
  end

end
