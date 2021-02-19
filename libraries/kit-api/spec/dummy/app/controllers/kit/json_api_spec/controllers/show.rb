require_relative '../../../../../config/initializers/api_config'

module Kit::JsonApiSpec::Controllers::Show # rubocop:disable Style/Documentation

  def self.endpoint(router_request:, query_params:, api_request:)
    Kit::Organizer.call(
      list: [
        Kit::Api::JsonApi::Services::Request::Import.method(:import),
        self.method(:add_api_request_condition),
        Kit::Api::Services::QueryBuilder.method(:build_query),
        Kit::Api::Services::QueryResolver.method(:resolve_query_node),
        self.method(:ensure_resolved),
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
      { route_type: :show, singular: true },
    ],
  )

  def self.add_api_request_condition(api_request:, router_request:)
    api_request[:condition] = { column: :id, op: :eq, values: [router_request[:params][:resource_id]] }

    [:ok, api_request: api_request]
  end

  def self.ensure_resolved(query_node:)
    if query_node[:records][0]&.dig(:raw_data)
      [:ok]
    else
      [:error, { detail: 'Could not find resource.', status_code: 404 }]
    end
  end

end
