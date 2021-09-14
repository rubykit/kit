module Kit::Auth::Endpoints::Web::Users::SignIn::WithPassword::Create

  def self.endpoint(router_request:)
    Kit::Organizer.call(
      list: [
        [:alias, :web_redirect_if_current_user!],
        Kit::Auth::Endpoints::Web::Users::SignIn::WithPassword::Create.method(:get_form_model),
        Kit::Auth::Endpoints::Web::Users::SignIn::WithPassword::Create.method(:create_sign_in),
        Kit::Auth::Endpoints::Web::Users::SignIn::WithPassword::Create.method(:handle_success),
        Kit::Auth::Endpoints::Web::Users::SignIn::WithPassword::Create.method(:handle_error),
      ],
      ctx:  { router_request: router_request },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|authorization_tokens|create',
    aliases: [
      'web|authorization_tokens|create',
    ],
    target:  self.method(:endpoint),
  )

  def self.get_form_model(router_request:)
    attributes = [:email, :password]
    form_model = router_request.params.slice(*attributes)

    [:ok, form_model: form_model]
  end

  def self.create_sign_in(router_request:, form_model:)
    status, ctx = Kit::Organizer.call(
      list: [
        ->(email:) { [:ok, user: Kit::Auth::Models::Read::User.find_by(email: email)] },
        Kit::Auth::Actions::Users::VerifyPassword,
        Kit::Auth::Actions::Users::SignInWeb,
      ],
      ctx:  {
        email:          form_model[:email],
        password:       form_model[:password],
        router_request: router_request,
      },
    )

    [:ok, action_status: status, action_ctx: ctx]
  end

  def self.handle_success(router_request:, action_status:, action_ctx:, redirect_url: nil)
    return [:ok] if action_status != :ok

    router_request.adapters[:http_rails][:cookies][:access_token] = { value: action_ctx[:oauth_access_token_plaintext_secret], encrypted: true }

    if !redirect_url
      redirect_url = Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|sign_in|after')
    end

    Kit::Router::Controllers::Http.redirect_to(location: redirect_url)
  end

  def self.handle_error(router_request:, action_status:, action_ctx:, page_component: nil)
    return [:ok] if action_status == :ok

    page_component ||= Kit::Auth::Components::Pages::Users::SignIn::WithPassword::NewComponent

    model = router_request.params.slice(:email, :password)

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
