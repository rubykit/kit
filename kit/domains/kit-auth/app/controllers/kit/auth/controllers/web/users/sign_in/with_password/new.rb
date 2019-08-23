module Kit::Auth::Controllers::Web::Users::SignIn::WithPassword
  module New

    def self.endpoint(request:)
      list = [
        :redirect_if_current_user!,
        self.method(:new_sign_in),
      ]

      Kit::Organizer.call({
        list: list,
        ctx: { request: request, },
      })
    end

    Kit::Router.register({
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

      page = Kit::Auth::Components::Pages::Users::SignIn::WithPassword::New.new(
        model:      model,
        csrf_token: request.http[:csrf_token],
      )
      content = page.local_render

      [:ok, {
        mime:    :html,
        content: content,
      }]
    end

  end
end