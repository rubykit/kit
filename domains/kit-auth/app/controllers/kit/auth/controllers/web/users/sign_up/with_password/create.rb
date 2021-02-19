module Kit::Auth::Controllers::Web::Users::SignUp::WithPassword
  module Create

    def self.endpoint(router_request:)
      Kit::Organizer.call(
        list: [
          [:alias, :web_redirect_if_current_user!],
          self.method(:create_user),
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

      status, ctx = Kit::Organizer.call(
        list: [
          Kit::Auth::Actions::Users::CreateWithPassword,
          Kit::Auth::Actions::Users::SignInWeb,
        ],
        ctx:  context,
      )

      if status == :ok
        router_request.http.cookies[:access_token] = { value: ctx[:oauth_access_token_plaintext_secret], encrypted: true }

        Kit::Router::Controllers::Http.redirect_to(
          location: Kit::Router::Services::Adapters::Http::Mountpoints.path(id: 'web|users|after_sign_up'),
        )
      else
        Kit::Router::Controllers::Http.render(
          component: Kit::Auth::Components::Pages::Users::SignUp::WithPassword::New,
          params:    {
            model:       model,
            csrf_token:  router_request.http[:csrf_token],
            errors_list: ctx[:errors],
          },
        )
      end
    end

  end
end
