module Kit::Auth::Controllers::Web::Users::ResetPasswordRequest
  module New

    def self.endpoint(request:)
      Kit::Organizer.call({
        ctx:  { request: request, },
        list: [
          :redirect_if_current_user!,
          self.method(:new_reset_password_request),
        ],
      })
    end

    Kit::Router::Services::Router.register({
      uid:     'kit_auth|web|users|reset_password_request|new',
      aliases: ['web|users|reset_password_request|new'],
      target:  self.method(:endpoint),
    })

    def self.new_reset_password_request(request:)
      model = { email: nil }

      page = Kit::Auth::Components::Pages::Users::ResetPasswordRequest::New.new(
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