module Kit::Auth::Controllers::Web::Users::SignIn::WithPassword
  module Create

    def self.endpoint(request:)
      Kit::Organizer.call({
        list: [
          :web_redirect_if_current_user!,
          self.method(:create_sign_in),
        ],
        ctx: { request: request, },
      })
    end

    Kit::Router::Services::Router.register({
      uid:     'kit_auth|web|authorization_tokens|create',
      aliases: [
        'web|authorization_tokens|create',
      ],
      target:  self.method(:endpoint),
    })

    def self.create_sign_in(request:)
      model   = request.params.slice(:email, :password)
      context = model.merge(
        request: request,
      )

      res, ctx = Kit::Organizer.call({
        ctx: context,
        list: [
          ->(email:) { [:ok, user: Kit::Auth::Models::Read::User.find_by(email: email)] },
          Kit::Auth::Actions::Users::VerifyPassword,
          Kit::Auth::Actions::Users::SignInWeb,
        ],
      })

      if res == :ok
        request.http.cookies[:access_token] = { value: ctx[:oauth_access_token_plaintext_secret], encrypted: true }

        Kit::Router::Controllers::Http.redirect_to(
          location: Kit::Router::Services::HttpRoutes.path(id: 'web|users|after_sign_in')
        )
      else
        Kit::Router::Controllers::Http.render(
          component: Kit::Auth::Components::Pages::Users::SignIn::WithPassword::New,
          params: {
            model:       model,
            csrf_token:  request.http[:csrf_token],
            errors_list: ctx[:errors],
          },
        )
      end
    end

  end
end