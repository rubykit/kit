module Kit::Auth::Controllers::Web::Users::SignUp::WithPassword
  module Create

    def self.endpoint(request:)
      list = [
        :redirect_if_current_user!,
        self.method(:create_user),
      ]

      Kit::Organizer.call({
        list: list,
        ctx: { request: request, },
      })
    end

    Kit::Router.register({
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
          location: Kit::Router.path(id: 'web|users|after_sign_up')
        )
      else
        page = Kit::Auth::Components::Pages::Users::SignUp::WithPassword::New.new(
          model:       model,
          csrf_token:  request.http[:csrf_token],
          errors_list: ctx[:errors],
        )
        content = page.local_render

        [:ok, {
          mime:    :html,
          content: content,
        }]
      end
    end

  end
end