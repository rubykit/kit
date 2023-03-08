module Kit::Auth::Endpoints::Api::Show # rubocop:disable Style/Documentation

  def self.endpoint(router_conn:, query_params:, api_request:)
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
        router_conn:  router_conn,
        query_params: query_params,
        api_request:  api_request,
      },
    )
  end

  def self.register_endpoints
    resources = {
      user_auth:  -> { Kit::Auth::Resources::Api::UserAuth.to_h },
      user_email: -> { Kit::Auth::Resources::Api::UserEmail.to_h },
    }

    resources.each do |name, resource|
      Kit::Router::Services::Router.register(
        uid:     "kit|auth|api|json_api|#{ name }|show",
        aliases: ["api|json_api|#{ name }|show"],
        target:  self.method(:endpoint),
        meta:    {
          route_defaults: {
            kit_api_top_level_resource: resource,
            kit_api_singular:           true,
          },
        },
      )
    end
  end

  def self.add_api_request_condition(api_request:, router_conn:)
    api_request[:condition] = { column: :id, op: :eq, values: [router_conn.request[:params][:resource_id]] }

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
