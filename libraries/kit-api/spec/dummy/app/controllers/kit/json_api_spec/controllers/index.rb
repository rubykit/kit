require_relative '../../../../../config/initializers/api_config'

module Kit::JsonApiSpec::Controllers::Index # rubocop:disable Style/Documentation

  def self.endpoint(router_request:, query_params:, api_request:)
    Kit::Organizer.call(
      list: [
        Kit::Api::JsonApi::Services::Request::Import.method(:import),
        Kit::Api::Services::QueryBuilder.method(:build_query),
        Kit::Api::Services::QueryResolver.method(:resolve_query_node),
        Kit::Api::JsonApi::Services::Serialization::Query.method(:serialize_query),
      ],
      ctx:  {
        router_request: router_request,
        query_params:   query_params,
        api_request:    api_request,
      },
    )
  end

  Kit::JsonApiSpec::Controllers.register_endpoints(
    config:   KIT_DUMMY_APP_API_CONFIG,
    endpoint: self.method(:endpoint),
    routes:   [
      { route_type: :index, singular: false },
    ],
  )

end
