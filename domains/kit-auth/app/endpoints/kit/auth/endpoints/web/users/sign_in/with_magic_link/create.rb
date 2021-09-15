module Kit::Auth::Endpoints::Web::Users::SignIn::WithMagicLink::Create

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Endpoints::Web::Users::SignIn::WithMagicLink::Create.method(:render),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|authorization_tokens|email|create',
    aliases: [
      'web|authorization_tokens|email|create',
    ],
    target:  self.method(:endpoint),
  )

  def self.render(router_conn:, page_component: nil)
    model = router_conn.request[:params].slice(:email)

    page_component ||= Kit::Auth::Components::Pages::Users::SignIn::WithMagicLink::AfterComponent

    Kit::Router::Controllers::Http.render(
      router_conn: router_conn,
      component:      page_component,
      params:         {
        email: model[:email],
      }
    )
  end

end
