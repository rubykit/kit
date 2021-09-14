module Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::Create

  def self.endpoint(router_request:)
    Kit::Organizer.call(
      list: [
        [:alias, :web_redirect_if_current_user!],
        Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::Create.method(:get_form_model),
        Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::Create.method(:create_user),
        Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::Create.method(:attempt_sign_in_on_error),
        Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::Create.method(:handle_success),
        Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::Create.method(:handle_error),
      ],
      ctx:  { router_request: router_request },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|users|create',
    aliases: [
      'web|users|create',
    ],
    target:  self.method(:endpoint),
  )

  def self.get_form_model(router_request:)
    attributes = [:email, :password, :password_confirmation]
    form_model = router_request.params.slice(*attributes)

    [:ok, form_model: form_model]
  end

  def self.create_user(router_request:, form_model:)
    status, ctx = Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::Users::CreateWithPassword,
        Kit::Auth::Actions::Users::SignInWeb,
      ],
      ctx:  {
        router_request: router_request,
        email:          form_model[:email],
        password:       form_model[:password],
      },
    )

    [:ok, action_status: status, action_ctx: ctx]
  end

  def self.attempt_sign_in_on_error(router_request:, form_model:, action_status:, action_ctx:)
    return [:ok] if action_status == :ok

    _status, ctx = Kit::Organizer.call(
      list: [Kit::Auth::Endpoints::Web::Users::SignIn::WithPassword::Create.method(:create_sign_in)],
      ctx:  {
        router_request: router_request,
        form_model:     form_model,
      },
    )

    if ctx[:action_status] == :ok
      [:ok, action_status: :ok, action_ctx: ctx[:action_ctx], was_sign_in: true]
    else
      [:ok]
    end
  end

  def self.handle_success(router_request:, action_status:, action_ctx:, was_sign_in: nil, redirect_url: nil)
    return [:ok] if action_status != :ok

    router_request.adapters[:http_rails][:cookies][:access_token] = { value: action_ctx[:oauth_access_token_plaintext_secret], encrypted: true }

    if !redirect_url
      route_id     = was_sign_in ? 'web|users|sign_in|after' : 'web|users|sign_up|after'
      redirect_url = Kit::Router::Adapters::Http::Mountpoints.path(id: route_id)
    end

    Kit::Router::Controllers::Http.redirect_to(location: redirect_url)
  end

  def self.handle_error(router_request:, action_status:, action_ctx:, page_component: nil)
    return [:ok] if action_status == :ok

    model = router_request.params.slice(:email, :password, :password_confirmation)

    page_component ||= Kit::Auth::Components::Pages::Users::SignUp::WithPassword::NewComponent

    Kit::Router::Controllers::Http.render(
      router_request: router_request,
      component:      page_component,
      params:         {
        model:       model,
        csrf_token:  router_request.adapters[:http_rails][:csrf_token],
        errors_list: action_ctx[:errors],
      },
    )
  end

end
