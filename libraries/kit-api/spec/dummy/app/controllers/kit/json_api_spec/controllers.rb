module Kit::JsonApiSpec::Controllers # rubocop:disable Style/Documentation

  # Register endpoints with the router for all Resources.
  def self.register_endpoints(config:, routes:, endpoint:)
    config[:resources].each do |_resource_name, resource_object|
      routes.each do |route|
        route_type = route[:route_type]
        singular   = route[:singular]

        route_id  = "specs|api|#{ resource_object[:name] }|#{ route_type }"
        route_uid = "kit_api|#{ route_id }"
        route_fn  = ->(router_request:) do
          self.api_endpoint_wrapper(
            endpoint:       endpoint,
            router_request: router_request,
            resource:       resource_object,
            singular:       singular,
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

  def self.api_endpoint_wrapper(router_request:, resource:, singular:, endpoint:)
    api_request = {
      config:             KIT_DUMMY_APP_API_CONFIG,
      top_level_resource: resource,
      singular:           singular,
    }

    status, ctx = Kit::Organizer.call(
      list: [
        Kit::Api::JsonApi::Controllers::JsonApi.method(:ensure_media_type),
        endpoint,
      ],
      ctx:  {
        router_request: router_request,
        query_params:   router_request[:params].to_h,
        api_request:    api_request,
      },
    )

    if status == :ok
      list = [
        Kit::Api::JsonApi::Controllers::JsonApi.method(:generate_success_router_response),
      ]
    else
      list = [
        Kit::Api::JsonApi::Controllers::Responses::Error.method(:generate_response),
      ]
    end

    Kit::Organizer.call(
      list: list,
      ctx:  ctx,
    )
  end

end
