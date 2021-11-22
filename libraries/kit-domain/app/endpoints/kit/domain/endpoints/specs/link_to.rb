# Endpoint that allow to reach PATCH / POST / PUT / DELETE routes.
module Kit::Domain::Endpoints::Specs::LinkTo

  def self.endpoint(router_conn:)
    Kit::Domain::Endpoints::Http.render(
      router_conn: router_conn,
      component:   Kit::Auth::DummyApp::Components::LinkToComponent,
      params:      {
        router_conn: router_conn,
      },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit-domain|specs|link_to',
    aliases: ['specs|link_to'],
    target:  self.method(:endpoint),
  )

end
