require_relative '../../../../../config/initializers/api_config'

module Kit::JsonApiSpec::Endpoints::Delete # rubocop:disable Style/Documentation

  def self.endpoint(router_conn:, query_params:, api_request:)
    Kit::Organizer.call(
      list: [
        Kit::Api::JsonApi::Services::Request::Import.method(:import),
        self.method(:delete),
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
        { route_type: :delete, singular: true },
      ],
    )
  end

  def self.delete(router_conn:, api_request:)
    resource       = api_request[:top_level_resource]

    model_class    = resource[:extra][:model_write]
    resource_id    = router_conn.request[:params][:resource_id]

    model_instance = model_class.find_by(id: resource_id)

    model_instance.destroy

    [:ok, status_code: 204, document: {}]
  end

end
