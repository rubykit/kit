module Kit::Auth::Controllers::Web::Users::SignUp::WithPassword::Create

  def self.endpoint(router_request:)
    Kit::Organizer.call(
      list: [
        [:alias, :web_redirect_if_current_user!],
        Kit::Auth::Controllers::Web::Users::SignUp::WithPassword::Create.method(:get_form_model),
        Kit::Auth::Controllers::Web::Users::SignUp::WithPassword::Create.method(:create_user),
        Kit::Auth::Controllers::Web::Users::SignUp::WithPassword::Create.method(:attempt_sign_in_on_error),
        Kit::Auth::Controllers::Web::Users::SignUp::WithPassword::Create.method(:render_or_redirect),
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
        model:          form_model,
      },
    )

    [:ok, action_status: status, action_ctx: ctx]
  end

  def self.attempt_sign_in_on_error(router_request:, form_model:, action_status:, action_ctx:)
    return [:ok] if action_status == :ok

    status, ctx = Kit::Organizer.call(
      list: [Kit::Auth::Controllers::Web::Users::SignIn::WithPassword::Create.method(:create_sign_in)],
      ctx:  {
        router_request: router_request,
        form_model:     form_model,
      },
    )

    if status == :ok
      [:ok, action_status: :ok, action_ctx: ctx[:action_ctx], was_sign_in: true]
    else
      [:ok]
    end
  end

  def self.render_or_redirect(router_request:, action_status:, action_ctx:, was_sign_in: nil, page_component: nil)
    if action_status == :ok
      router_request.http.cookies[:access_token] = { value: action_ctx[:oauth_access_token_plaintext_secret], encrypted: true }

      route_id = was_sign_in ? 'web|users|after_sign_in' : 'web|users|after_sign_up'

      Kit::Router::Controllers::Http.redirect_to(
        location: Kit::Router::Services::Adapters::Http::Mountpoints.path(id: route_id),
      )
    else
      model = router_request.params.slice(:email, :password, :password_confirmation)

      page_component ||= Kit::Auth::Components::Pages::Users::SignUp::WithPassword::NewComponent

      Kit::Router::Controllers::Http.render(
        router_request: router_request,
        component:      page_component,
        params:         {
          model:       model,
          csrf_token:  router_request.http[:csrf_token],
          errors_list: action_ctx[:errors],
        },
      )
    end
  end

end
