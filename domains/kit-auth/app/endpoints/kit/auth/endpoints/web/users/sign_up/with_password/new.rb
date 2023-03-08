module Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::New

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

  def self.register_endpoint
    Kit::Router::Services::Router.register(
      uid:     'kit_auth|web|users|sign_up|with_password|new',
      aliases: {
        'web|users|sign_up|with_password|new' => [
          'web|users|sign_up|new',
        ],
      },
      target:  self.method(:endpoint),
    )
  end

  def self.set_form_model
    form_model = { email: nil, password: nil }

    [:ok, form_model: form_model]
  end

  def self.set_page_component(component: nil)
    [:ok, component: component || Kit::Auth::Components::Pages::Users::SignUp::WithPassword::NewComponent]
  end

end
