module Kit::Auth::Endpoints::Web::Users::SignIn::WithPassword::New

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        [:alias, :web_redirect_if_current_user!],
        Kit::Auth::Endpoints::Web::Users::SignIn::WithPassword::New.method(:new_sign_in),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|authorization_tokens|new',
    target:  self.method(:endpoint),
    aliases: {
      'web|authorization_tokens|new' => {
        'web|users|sign_in|new' => {
          'web|users|sign_in' => [
            'web|users|sign_out|after',
            'web|users|password_reset_request|after',
          ],
        },
      },
    },
  )

  def self.new_sign_in(router_conn:, page_component: nil)
    model = { email: nil, password: nil }

    page_component ||= Kit::Auth::Components::Pages::Users::SignIn::WithPassword::NewComponent

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
