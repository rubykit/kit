module Kit::Domain::Endpoints::Mailer

  # Render helper for mailers.
  #
  # Extracted because it fits a common pattern we're currently using.
  def self.render(router_conn:, component:, component_params:, headers:)
    component_instance = component.new(**component_params)
    content            = component_instance.local_render(router_conn: router_conn)

    router_conn[:response].deep_merge!({
      content: content,
      mailer:  {
        headers: headers,
      },
    })

    [:ok, router_conn: router_conn]
  end

end
