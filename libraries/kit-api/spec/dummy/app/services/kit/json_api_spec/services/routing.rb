module Kit::JsonApiSpec::Services::Routing # rubocop:disable Style/Documentation

  # Register endpoints with the router for all provided `resources`.
  def self.register_endpoints(resources:, routes:, endpoint:)
    resources.each do |_resource_name, resource_object|
      routes.each do |route|
        route_id  = "specs|api|#{ resource_object[:name] }|#{ route[:route_type] }"
        route_uid = "kit_api|#{ route_id }"

        Kit::Router::Services::Router.register(
          uid:     route_uid,
          aliases: [route_id],
          target:  endpoint,
          meta:    {
            route_defaults: {
              kit_api_top_level_resource: resource_object,
              kit_api_singular:           route[:singular],
            },
          },
        )
      end
    end
  end

end
