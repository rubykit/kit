module Kit::Auth::Endpoints::Web::Users::SignIn::WithMagicLink::New

  def self.endpoint(router_request:)
    Kit::Organizer.call(
      list: [
        [:alias, :web_redirect_if_current_user!],
        Kit::Auth::Endpoints::Web::Users::SignIn::WithMagicLink::New.method(:new_sign_in),
      ],
      ctx:  { router_request: router_request },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|authorization_tokens|email|new',
    target:  self.method(:endpoint),
    aliases: {
      'web|authorization_tokens|email|new' => ['web|users|sign_in|email|new'],
    },
  )

  def self.new_sign_in(router_request:, page_component: nil)
    model = { email: nil, password: nil }

    page_component ||= Kit::Auth::Components::Pages::Users::SignIn::WithMagicLink::NewComponent

    Kit::Router::Controllers::Http.render(
      router_request: router_request,
      component:      page_component,
      params:         {
        model:      model,
        csrf_token: router_request.adapters[:http_rails][:csrf_token],
      },
    )
  end

end
