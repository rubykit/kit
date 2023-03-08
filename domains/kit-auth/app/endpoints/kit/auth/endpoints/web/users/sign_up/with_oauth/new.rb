module Kit::Auth::Endpoints::Web::Users::SignUp::WithOauth::New

  def self.endpoint(router_conn:, component: nil)
    Kit::Organizer.call(
      list: [
        [:alias, :web_redirect_if_session_user!],
        self.method(:set_page_component),
        Kit::Domain::Endpoints::Http.method(:render),
      ],
      ctx:  {
        router_conn: router_conn,
        component:   component,
      },
    )
  end

  def self.register_endpoint
    Kit::Router::Services::Router.register(
      uid:     'kit_auth|web|users|sign_up|with_oauth|new',
      aliases: [
        'web|users|sign_up|with_oauth|new',
      ],
      target:  self.method(:endpoint),
    )
  end

  def self.set_page_component(component: nil)
    [:ok, component: component || Kit::Auth::Components::Pages::Users::SignUp::WithOauth::NewComponent]
  end

end
