module Kit::Auth::Controllers::Web::Users::SignIn::WithPassword
  module New

    def self.endpoint(router_request:)
      Kit::Organizer.call({
        list: [
          [:alias, :web_redirect_if_current_user!],
          self.method(:new_sign_in),
        ],
        ctx:  { router_request: router_request },
      })
    end

    Kit::Router::Services::Router.register({
      uid:     'kit_auth|web|authorization_tokens|new',
      target:  self.method(:endpoint),
      aliases: {
        'web|authorization_tokens|new' => {
          'web|users|sign_in|new' => {
            'web|users|sign_in' => [
              'web|users|after_sign_out',
              'web|users|after_reset_password_request',
            ],
          },
        },
      },
    })

    def self.new_sign_in(router_request:)
      model = { email: nil, password: nil }

      Kit::Router::Controllers::Http.render(
        component: Kit::Auth::Components::Pages::Users::SignIn::WithPassword::New,
        params:    {
          model:      model,
          csrf_token: router_request.http[:csrf_token],
        },
      )
    end

  end
end
