module Kit::Auth::Endpoints::Web::Users::SignIn::LinkRequest::Create

  def self.endpoint(router_conn:, component: nil)
    Kit::Organizer.call(
      ok:    [
        [:alias, :web_redirect_if_session_user!],
        self.method(:set_form_model),
        self.method(:create_sign_in_link_request),
        self.method(:render_page),
      ],
      error: [
        Kit::Auth::Endpoints::Web::Users::SignIn::LinkRequest::New.method(:set_page_component),
        Kit::Domain::Endpoints::Http.method(:render_form_page),
      ],
      ctx:   {
        router_conn: router_conn,
        component:   component,
      },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|users|sign_in|with_magic_link|request|create',
    aliases: [
      'web|users|sign_in|with_magic_link|request|create',
    ],
    target:  self.method(:endpoint),
  )

  def self.set_form_model(router_conn:)
    form_model = router_conn.request[:params].slice(:email)

    [:ok, form_model: form_model]
  end

  def self.create_sign_in_link_request(router_conn:, form_model:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::Users::RequestSignInLink,
      ],
      ctx:  {
        router_conn: router_conn,
        email:       form_model[:email],
      },
    )
  end

  def self.render_page(router_conn:, form_model:, page_component: nil)
    page_component ||= Kit::Auth::Components::Pages::Users::SignIn::WithMagicLink::AfterComponent

    Kit::Domain::Endpoints::Http.render(
      router_conn: router_conn,
      component:   page_component,
      params:      {
        email: form_model[:email],
      },
    )
  end

end
