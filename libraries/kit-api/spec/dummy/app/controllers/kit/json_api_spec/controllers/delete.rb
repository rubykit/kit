require_relative '../../../../../config/initializers/api_config'

module Kit::JsonApiSpec::Controllers::Delete # rubocop:disable Style/Documentation

  def self.endpoint(router_request:, top_level_resource:, singular:)
    api_request = {
      config:             KIT_DUMMY_APP_API_CONFIG,
      top_level_resource: top_level_resource,
      singular:           singular,
    }

    Kit::Organizer.call({
      list: [
        Kit::Api::JsonApi::Controllers::JsonApi.method(:ensure_media_type),
        Kit::Api::JsonApi::Services::Request::Import.method(:import),
        self.method(:delete),
        Kit::Api::JsonApi::Controllers::JsonApi.method(:generate_router_response),
      ],
      ctx:  {
        api_request:    api_request,
        query_params:   router_request[:params],
        router_request: router_request,
        resource:       top_level_resource,
      },
    })
  end

  Kit::JsonApiSpec::Controllers.register_endpoints(
    config:   KIT_DUMMY_APP_API_CONFIG,
    endpoint: self.method(:endpoint),
    routes:   [
      { route_type: :delete, singular: true },
    ],
  )

  def self.delete(router_request:, resource:)
    model_class    = resource[:extra][:model_write]
    resource_id    = router_request.params[:resource_id]

    model_instance = model_class.find_by(id: resource_id)

    model_instance.destroy

    [:ok, status_code: 204, document: {}]
  end

end
