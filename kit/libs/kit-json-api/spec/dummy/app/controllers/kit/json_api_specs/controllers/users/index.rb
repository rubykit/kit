module Kit::JsonApiSpecs::Controllers::Users
  module Index

    ROUTE_ID  = 'specs|api|users|index'
    ROUTE_UID = "kit_json_api|specs|#{ROUTE_ID}"

    def self.endpoint(request:)
      Kit::Organizer.call({
        list: [
          #Kit::JsonApi::Controllers::JsonApi.method(:ensure_media_type),
          #self.method(:add_endpoint_json_api_query_data),
          #Kit::JsonApi::Controllers::JsonApi.method(:validate_query),
          self.method(:load_and_render),
        ],
        ctx: { request: request, },
      })
    end

    Kit::Router::Services::Router.register(
      uid:     ROUTE_UID,
      aliases: [ROUTE_ID,],
      target:  self.method(:endpoint),
    )

    def self.add_endpoint_json_api_query_data(json_api_query:)
      # TODO: add endpoint specific restrictions or defaults for the JsonApiQuery
      [:ok, json_api_query: json_api_query]
    end

    # TODO: probably don't need this for access ?
    def self.load_and_render
      [:ok, {
        response: {
          mime:     :json_api,
          content:  { "status" => "success" }.to_json.to_s,
          metadata: {
            http: {
              status: 200,
            },
          },
        },
      }]
    end

  end
end