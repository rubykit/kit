module Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::New

  def self.endpoint(router_request:)
    Kit::Organizer.call(
      list: [
        [:alias, :web_redirect_if_current_user!],
        self.method(:new_sign_up),
      ],
      ctx:  { router_request: router_request },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|users|new',
    aliases: {
      'web|users|new' => 'web|users|sign_up',
    },
    target:  self.method(:endpoint),
  )

  def self.new_sign_up(router_request:, page_component: nil)
    model = { email: nil, password: nil }

    page_component ||= Kit::Auth::Components::Pages::Users::SignUp::WithPassword::NewComponent

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
