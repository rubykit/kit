require_relative '../../../../../config/initializers/api_config'

module Kit::JsonApiSpec::Controllers::Create # rubocop:disable Style/Documentation

  def self.endpoint(router_request:, query_params:, api_request:)
    Kit::Organizer.call({
      list: [
        Kit::Api::JsonApi::Services::Request::Import.method(:import),
        self.method(:create),
        Kit::Api::Controllers::Api.method(:generate_resolved_query),
        Kit::Api::JsonApi::Services::Serialization::Query.method(:serialize_query),
      ],
      ctx:  {
        router_request: router_request,
        query_params:   query_params,
        api_request:    api_request,
      },
    })
  end

  Kit::JsonApiSpec::Controllers.register_endpoints(
    config:   KIT_DUMMY_APP_API_CONFIG,
    endpoint: self.method(:endpoint),
    routes:   [
      { route_type: :create, singular: true },
    ],
  )

  def self.create(router_request:, api_request:)
    resource    = api_request[:top_level_resource]
    model_class = resource[:extra][:model_write]

    data       = router_request.params.dig(:data, :attributes) || {}
    _, ctx     = Kit::Api::Controllers::Api.sanitize_writeable_attributes(data: data, template: resource[:writeable_attributes])
    attributes = ctx[:model_attributes]

    data       = router_request.params.dig(:data, :relationships) || {}
    _, ctx     = Kit::Api::Controllers::Api.sanitize_writeable_relationships(data: data, template: resource[:writeable_relationships])
    relationships = ctx[:model_attributes]

    values = {}.merge(attributes).merge(relationships)

    model_instance = model_class.new(values)
    model_instance.save

    [:ok, model_instance: model_instance, status_code: 201]
  end

end
