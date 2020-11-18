require_relative '../../../../../config/initializers/api_config'

module Kit::JsonApiSpec::Controllers::Create # rubocop:disable Style/Documentation

  def self.to_object(router_request:)
  end

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
        self.method(:create),
        Kit::Api::JsonApi::Services::Serialization::Query.method(:serialize_query),
        Kit::Api::JsonApi::Controllers::JsonApi.method(:generate_router_response),
      ],
      ctx:  {
        api_request:    api_request,
        query_params:   router_request[:params],
        router_request: router_request,
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

  def self.create(router_request:)
    binding.pry
    [:ok]
  end

end
