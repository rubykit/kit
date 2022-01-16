module Kit::Auth::Endpoints::Web::Users::SignIn::WithPassword::New

  def self.endpoint(router_conn:, component: nil)
    Kit::Organizer.call(
      list: [
        [:alias, :web_redirect_if_session_user!],
        self.method(:set_form_model),
        self.method(:set_page_component),
        Kit::Domain::Endpoints::Http.method(:render_form_page),
      ],
      ctx:  {
        router_conn: router_conn,
        component:   component,
      },
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

  def self.set_form_model
    form_model = { email: nil, password: nil }

    [:ok, form_model: form_model]
  end

  def self.set_page_component(component: nil)
    [:ok, component: component || Kit::Auth::Components::Pages::Users::SignIn::WithPassword::NewComponent]
  end

end
