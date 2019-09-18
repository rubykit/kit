module Kit::Auth::Controllers::Web::Users::SignIn::WithPassword
  module New

    def self.endpoint(request:)
      Kit::Organizer.call({
        list: [
          :web_redirect_if_current_user!,
          self.method(:new_sign_in),
        ],
        ctx: { request: request, },
      })
    end

    Kit::Router::Services::Router.register({
      uid:     'kit_auth|web|authorization_tokens|new',
      aliases: [
        'web|authorization_tokens|new',
        'web|users|sign_in',
        'web|users|sign_in|new',
        'web|users|after_sign_out',
        'web|users|after_reset_password_request',
      ],
      target:  self.method(:endpoint),
    })

    def self.new_sign_in(request:)
      model = { email: nil, password: nil }

      Kit::Router::Controllers::Http.render(
        component: Kit::Auth::Components::Pages::Users::SignIn::WithPassword::New,
        params: {
          model:      model,
          csrf_token: request.http[:csrf_token],
        },
      )
    end

  end
end