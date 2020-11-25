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
        self.method(:generate_query),
        Kit::Api::JsonApi::Services::Serialization::Query.method(:serialize_query),
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
      { route_type: :create, singular: true },
    ],
  )

  def self.sanitize_params(template:, data:)
    result = {}

    template.each do |name, tpl_action|
      param_value = data[name]
      if tpl_action.is_a?(::Symbol)
        res = [tpl_action, param_value]
      else
        res = tpl_action.call(data: data, value: param_value)
      end

      result[res[0]] = res[1]
    end

    [:ok, values: result]
  end

  def self.create(router_request:, resource:)
    template = {
      name:            :name,
      'date-of-birth': ->(data:, value:) { [:date_of_birth, value ? Date.parse(value) : nil] },
      'date-of-death': ->(data:, value:) { [:date_of_death, value ? Date.parse(value) : nil] },
    }

    data   = router_request.params.dig(:data, :attributes) || {}
    _, ctx = sanitize_params(data: data, template: template)

    model_class    = resource[:extra][:model_write]
    model_instance = model_class.new(ctx[:values])
    model_instance.save

    [:ok, model_instance: model_instance, status_code: 201]
  end

  def self.generate_query(resource:, model_instance:)
    api_request = {
      config:             KIT_DUMMY_APP_API_CONFIG,
      top_level_resource: resource,
      singular:           true,
    }

    _, ctx = Kit::Api::Services::QueryBuilder.build_resolved_query(
      api_request: api_request,
      resource:    resource,
      raw_data:    model_instance,
    )

    [:ok, query_node: ctx[:query_node]]
  end

end
