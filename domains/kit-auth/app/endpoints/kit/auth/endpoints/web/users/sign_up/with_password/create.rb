module Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::Create

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        [:alias, :web_redirect_if_current_user!],
        Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::Create.method(:get_form_model),
        Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::Create.method(:create_user),
        Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::Create.method(:attempt_sign_in_on_error),
        Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::Create.method(:handle_success),
        Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::Create.method(:handle_error),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|users|create',
    aliases: [
      'web|users|create',
    ],
    target:  self.method(:endpoint),
  )

  def self.get_form_model(router_conn:)
    attributes = [:email, :password, :password_confirmation]
    form_model = router_conn.request[:params].slice(*attributes)

    [:ok, form_model: form_model]
  end

  def self.create_user(router_conn:, form_model:)
    status, ctx = Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::Users::CreateWithPassword,
        Kit::Auth::Actions::Users::SignInWeb,
      ],
      ctx:  {
        router_conn: router_conn,
        email:       form_model[:email],
        password:    form_model[:password],
      },
    )

    [:ok, action_status: status, action_ctx: ctx]
  end

  def self.attempt_sign_in_on_error(router_conn:, form_model:, action_status:, action_ctx:)
    return [:ok] if action_status == :ok

    _status, ctx = Kit::Organizer.call(
      list: [Kit::Auth::Endpoints::Web::Users::SignIn::WithPassword::Create.method(:create_sign_in)],
      ctx:  {
        router_conn: router_conn,
        form_model:  form_model,
      },
    )

    if ctx[:action_status] == :ok
      [:ok, action_status: :ok, action_ctx: ctx[:action_ctx], was_sign_in: true]
    else
      [:ok]
    end
  end

  def self.handle_success(router_conn:, action_status:, action_ctx:, was_sign_in: nil, redirect_url: nil)
    return [:ok] if action_status != :ok

    router_conn.response[:http][:cookies][:access_token] = { value: action_ctx[:oauth_access_token_plaintext_secret], encrypted: true }

    if !redirect_url
      route_id     = was_sign_in ? 'web|users|sign_in|after' : 'web|users|sign_up|after'
      redirect_url = Kit::Router::Adapters::Http::Mountpoints.path(id: route_id)
    end

    Kit::Router::Controllers::Http.redirect_to(
      router_conn: router_conn,
      location:    redirect_url,
    )
  end

  def self.handle_error(router_conn:, action_status:, action_ctx:, page_component: nil)
    return [:ok] if action_status == :ok

    model = router_conn.request[:params].slice(:email, :password, :password_confirmation)

    page_component ||= Kit::Auth::Components::Pages::Users::SignUp::WithPassword::NewComponent

    Kit::Router::Controllers::Http.render(
      router_conn: router_conn,
      component:   page_component,
      params:      {
        model:       model,
        csrf_token:  router_conn.request[:http][:csrf_token],
        errors_list: action_ctx[:errors],
      },
    )
  end

end
