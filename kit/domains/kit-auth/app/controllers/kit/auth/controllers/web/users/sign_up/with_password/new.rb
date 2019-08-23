module Kit::Auth::Controllers::Web::Users::SignUp::WithPassword
  module New

    def self.endpoint(request:)
      list = [
        :redirect_if_current_user!,
        self.method(:new_sign_up),
      ]

      Kit::Organizer.call({
        list: list,
        ctx: { request: request, },
      })
    end

    Kit::Router.register({
      uid:     'kit_auth|web|users|new',
      aliases: [
        'web|users|new',
        'web|users|sign_up',
      ],
      target:  self.method(:endpoint),
    })

    def self.new_sign_up(request:)
      model = { email: nil, password: nil }

      content = Kit::Auth::Components::Pages::Users::SignUp::WithPassword::New.new(
        model:      model,
        csrf_token: request.http[:csrf_token],
      ).local_render

      [:ok, {
        mime:    :html,
        content: content,
      }]
    end

  end
end