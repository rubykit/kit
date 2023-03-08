# Endpoint that allow to reach PATCH / POST / PUT / DELETE routes.
module Kit::Domain::Endpoints::Specs::LinkTo

  def self.endpoint(router_conn:)
    Kit::Domain::Endpoints::Http.render(
      router_conn: router_conn,
      component:   Kit::Domain::Components::Specs::LinkToComponent,
      params:      {
        router_conn: router_conn,
      },
    )
  end

  def self.register_endpoint
    Kit::Router::Services::Router.register(
      uid:     'kit-domain|specs|link_to',
      aliases: ['specs|link_to'],
      target:  self.method(:endpoint),
    )
  end

end
