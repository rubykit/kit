module Kit::Auth::Endpoints::Web::Users::SignIn::WithMagicLink::Create

  def self.endpoint(router_request:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Endpoints::Web::Users::SignIn::WithMagicLink::Create.method(:render),
      ],
      ctx:  { router_request: router_request },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|authorization_tokens|email|create',
    aliases: [
      'web|authorization_tokens|email|create',
    ],
    target:  self.method(:endpoint),
  )

  def self.render(router_request:, page_component: nil)
    model = router_request.params.slice(:email)

    page_component ||= Kit::Auth::Components::Pages::Users::SignIn::WithMagicLink::AfterComponent

    Kit::Router::Controllers::Http.render(
      router_request: router_request,
      component:      page_component,
      params:         {
        email: model[:email],
      }
    )
  end

end
