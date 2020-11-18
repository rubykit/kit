module Kit::JsonApiSpec::Controllers # rubocop:disable Style/Documentation

  # Register endpoints with the router for all Resources.
  def self.register_endpoints(config:, routes:, endpoint:)
    config[:resources].each do |_resource_name, resource_object|
      routes.each do |route_type:, singular:|
        route_id  = "specs|api|#{ resource_object[:name] }|#{ route_type }"
        route_uid = "kit_api|#{ route_id }"
        route_fn  = ->(router_request:) do
          endpoint.call(
            router_request:     router_request,
            top_level_resource: resource_object,
            singular:           singular,
          )
        end

        Kit::Router::Services::Router.register(
          uid:     route_uid,
          aliases: [route_id],
          target:  route_fn,
        )
      end
    end
  end

end
