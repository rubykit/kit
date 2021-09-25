module Kit::Auth::Endpoints::Web::Users::SignIn::LinkRequest::New

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
    uid:     'kit_auth|web|users|sign_in_link_request|new',
    target:  self.method(:endpoint),
    aliases: ['web|users|sign_in_link_request|new'],
  )

  def self.set_form_model
    form_model = { email: nil, password: nil }

    [:ok, form_model: form_model]
  end

  def self.set_page_component
    [:ok, component: Kit::Auth::Components::Pages::Users::SignIn::WithMagicLink::NewComponent]
  end

end
