require_relative '../../../../../config/initializers/api_config'

module Kit::JsonApiSpec::Endpoints::Create # rubocop:disable Style/Documentation

  def self.endpoint(router_conn:, query_params:, api_request:)
    Kit::Organizer.call(
      list: [
        Kit::Api::JsonApi::Services::Request::Import.method(:import),
        self.method(:create),
        Kit::Api::Services::Endpoints.method(:generate_resolved_query),
        Kit::Api::JsonApi::Services::Serialization::Query.method(:serialize_query),
      ],
      ctx:  {
        router_conn:  router_conn,
        query_params: query_params,
        api_request:  api_request,
      },
    )
  end

  def self.register_endpoints
    Kit::JsonApiSpec::Services::Routing.register_endpoints(
      resources: KIT_DUMMY_APP_API_CONFIG[:resources],
      endpoint:  self.method(:endpoint),
      routes:    [
        { route_type: :create, singular: true },
      ],
    )
  end

  def self.create(router_conn:, api_request:)
    resource    = api_request[:top_level_resource]
    model_class = resource[:extra][:model_write]

    data       = router_conn.request.dig(:http, :params_body, :data, :attributes) || {}
    _, ctx     = Kit::Api::Services::Endpoints.sanitize_writeable_attributes(data: data, template: resource[:writeable_attributes])
    attributes = ctx[:model_attributes]

    data       = router_conn.request.dig(:http, :params_body, :data, :relationships) || {}
    _, ctx     = Kit::Api::Services::Endpoints.sanitize_writeable_relationships(data: data, template: resource[:writeable_relationships])
    relationships = ctx[:model_attributes]

    values = {}.merge(attributes).merge(relationships)

    model_instance = model_class.new(values)
    model_instance.save

    [:ok, model_instance: model_instance, status_code: 201]
  end

end
