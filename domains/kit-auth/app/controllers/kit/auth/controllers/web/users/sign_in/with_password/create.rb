module Kit::Auth::Controllers::Web::Users::SignIn::WithPassword::Create

  def self.endpoint(router_request:)
    Kit::Organizer.call(
      list: [
        [:alias, :web_redirect_if_current_user!],
        Kit::Auth::Controllers::Web::Users::SignIn::WithPassword::Create.method(:create_sign_in),
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

  def self.create_sign_in(router_request:, page_component: nil)
    model   = router_request.params.slice(:email, :password)
    context = model.merge(
      router_request: router_request,
    )

    res, ctx = Kit::Organizer.call(
      list: [
        ->(email:) { [:ok, user: Kit::Auth::Models::Read::User.find_by(email: email)] },
        Kit::Auth::Actions::Users::VerifyPassword,
        Kit::Auth::Actions::Users::SignInWeb,
      ],
      ctx:  context,
    )

    if res == :ok
      router_request.http.cookies[:access_token] = { value: ctx[:oauth_access_token_plaintext_secret], encrypted: true }

      Kit::Router::Controllers::Http.redirect_to(
        location: Kit::Router::Services::Adapters::Http::Mountpoints.path(id: 'web|users|after_sign_in'),
      )
    else
      page_component ||= Kit::Auth::Components::Pages::Users::SignIn::WithPassword::NewComponent

      Kit::Router::Controllers::Http.render(
        router_request: router_request,
        component:      page_component,
        params:         {
          model:       model,
          csrf_token:  router_request.http[:csrf_token],
          errors_list: ctx[:errors],
        },
      )
    end
  end

end
