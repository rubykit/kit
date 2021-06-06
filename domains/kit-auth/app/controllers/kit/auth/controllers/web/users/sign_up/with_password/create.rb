module Kit::Auth::Controllers::Web::Users::SignUp::WithPassword::Create

  def self.endpoint(router_request:)
    Kit::Organizer.call(
      list: [
        [:alias, :web_redirect_if_current_user!],
        Kit::Auth::Controllers::Web::Users::SignUp::WithPassword::Create.method(:create_user),
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

  def self.create_user(router_request:)
    model   = router_request.params.slice(:email, :password, :password_confirmation)
    context = model.merge(
      router_request: router_request,
    )

    signup_status, signup_ctx = Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::Users::CreateWithPassword,
        Kit::Auth::Actions::Users::SignInWeb,
      ],
      ctx:  context,
    )

    [:ok, signup_status: signup_status, signup_ctx: signup_ctx]
  end

  def self.render_or_redirect(router_request:, signup_status:, signup_ctx:, page_component: nil)
    if signup_status == :ok
      router_request.http.cookies[:access_token] = { value: signup_ctx[:oauth_access_token_plaintext_secret], encrypted: true }

      Kit::Router::Controllers::Http.redirect_to(
        location: Kit::Router::Services::Adapters::Http::Mountpoints.path(id: 'web|users|after_sign_up'),
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
          errors_list: signup_ctx[:errors],
        },
      )
    end
  end

end
