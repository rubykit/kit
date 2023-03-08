module Kit::Auth::Endpoints::Api::Index # rubocop:disable Style/Documentation

  def self.endpoint(router_conn:, query_params:, api_request:)
    Kit::Organizer.call(
      ok:  [
        Kit::Api::JsonApi::Services::Request::Import.method(:import),
        Kit::Api::Services::QueryBuilder.method(:build_query),
        Kit::Api::Services::QueryResolver.method(:resolve_query_node),
        Kit::Api::JsonApi::Services::Serialization::Query.method(:serialize_query),
      ],
      ctx: {
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
        uid:     "kit|auth|api|json_api|#{ name }|index",
        aliases: ["api|json_api|#{ name }|index"],
        target:  self.method(:endpoint),
        meta:    {
          route_defaults: {
            kit_api_top_level_resource: resource,
            kit_api_singular:           false,
          },
        },
      )
    end
  end

end
