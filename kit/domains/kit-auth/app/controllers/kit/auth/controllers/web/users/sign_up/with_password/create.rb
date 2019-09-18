module Kit::Auth::Controllers::Web::Users::SignUp::WithPassword
  module Create

    def self.endpoint(request:)
      Kit::Organizer.call({
        list: [
          :web_redirect_if_current_user!,
          self.method(:create_user),
        ],
        ctx: { request: request, },
      })
    end

    Kit::Router::Services::Router.register({
      uid:     'kit_auth|web|users|create',
      aliases: [
        'web|users|create',
      ],
      target:  self.method(:endpoint),
    })

    def self.create_user(request:)
      model   = request.params.slice(:email, :password, :password_confirmation)
      context = model.merge(
        request: request,
      )

      status, ctx = Kit::Organizer.call({
        ctx: context,
        list: [
          Kit::Auth::Actions::Users::CreateWithPassword,
          Kit::Auth::Actions::Users::SignInWeb,
        ],
      })

      if status == :ok
        request.http.cookies[:access_token] = { value: ctx[:oauth_access_token_plaintext_secret], encrypted: true }

        Kit::Router::Controllers::Http.redirect_to(
          location: Kit::Router::Services::HttpRoutes.path(id: 'web|users|after_sign_up')
        )
      else
        Kit::Router::Controllers::Http.render(
          component: Kit::Auth::Components::Pages::Users::SignUp::WithPassword::New,
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