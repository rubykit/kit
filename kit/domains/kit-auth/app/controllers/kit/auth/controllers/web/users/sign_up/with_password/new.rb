module Kit::Auth::Controllers::Web::Users::SignUp::WithPassword
  module New

    def self.endpoint(request:)
      Kit::Organizer.call({
        list: [
          :web_redirect_if_current_user!,
          self.method(:new_sign_up),
        ],
        ctx: { request: request, },
      })
    end

    Kit::Router::Services::Router.register({
      uid:     'kit_auth|web|users|new',
      aliases: [
        'web|users|new',
        'web|users|sign_up',
      ],
      target:  self.method(:endpoint),
    })

    def self.new_sign_up(request:)
      model = { email: nil, password: nil }

      Kit::Router::Controllers::Http.render(
        component: Kit::Auth::Components::Pages::Users::SignUp::WithPassword::New,
        params: {
          model:      model,
          csrf_token: request.http[:csrf_token],
        },
      )
    end

  end
end