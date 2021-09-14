module Kit::Auth::Endpoints::Web::Users::PasswordResetRequest::New

  def self.endpoint(router_request:)
    Kit::Organizer.call(
      list: [
        [:alias, :web_redirect_if_current_user!],
        self.method(:new_password_reset_request),
      ],
      ctx:  { router_request: router_request },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|users|password_reset_request|new',
    aliases: ['web|users|password_reset_request|new'],
    target:  self.method(:endpoint),
  )

  def self.new_password_reset_request(router_request:)
    model = { email: nil }

    Kit::Router::Controllers::Http.render(
      router_request: router_request,
      component:      Kit::Auth::Components::Pages::Users::PasswordResetRequest::NewComponent,
      params:         {
        model:      model,
        csrf_token: router_request.adapters[:http_rails][:csrf_token],
      },
    )
  end

end
