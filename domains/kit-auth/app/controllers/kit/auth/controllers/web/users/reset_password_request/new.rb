module Kit::Auth::Controllers::Web::Users::ResetPasswordRequest
  module New

    def self.endpoint(router_request:)
      Kit::Organizer.call({
        ctx:  { router_request: router_request },
        list: [
          [:alias, :web_redirect_if_current_user!],
          self.method(:new_reset_password_request),
        ],
      })
    end

    Kit::Router::Services::Router.register({
      uid:     'kit_auth|web|users|reset_password_request|new',
      aliases: ['web|users|reset_password_request|new'],
      target:  self.method(:endpoint),
    })

    def self.new_reset_password_request(router_request:)
      model = { email: nil }

      Kit::Router::Controllers::Http.render(
        component: Kit::Auth::Components::Pages::Users::ResetPasswordRequest::New,
        params:    {
          model:      model,
          csrf_token: router_request.http[:csrf_token],
        },
      )
    end

  end
end
