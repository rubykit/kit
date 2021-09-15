module Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::New

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        [:alias, :web_redirect_if_current_user!],
        self.method(:new_sign_up),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|users|new',
    aliases: {
      'web|users|new' => 'web|users|sign_up',
    },
    target:  self.method(:endpoint),
  )

  def self.new_sign_up(router_conn:, page_component: nil)
    model = { email: nil, password: nil }

    page_component ||= Kit::Auth::Components::Pages::Users::SignUp::WithPassword::NewComponent

    Kit::Router::Controllers::Http.render(
      router_conn: router_conn,
      component:      page_component,
      params:         {
        model:      model,
        csrf_token: router_conn.request[:http][:csrf_token],
      },
    )
  end

end
