module Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::New

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        [:alias, :web_redirect_if_current_user!],
        self.method(:set_form_model),
        self.method(:set_page_component),
        Kit::Domain::Endpoints::Http.method(:render_form_page),
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

  def self.set_form_model
    form_model = { email: nil, password: nil }

    [:ok, form_model: form_model]
  end

  def self.set_page_component
    [:ok, component: Kit::Auth::Components::Pages::Users::SignUp::WithPassword::NewComponent]
  end

end
