module Kit::JsonApiSpec::Controllers::Authors::Index

  ROUTE_ID  = 'specs|api|users|index'
  ROUTE_UID = "kit_json_api|specs|#{ ROUTE_ID }"

  def self.endpoint(request:)
    Kit::Organizer.call({
      list: [
        #Kit::JsonApi::Controllers::JsonApi.method(:ensure_media_type),
        #self.method(:add_endpoint_json_api_query_data),
        self.method(:tmp_create_query),
        #Kit::JsonApi::Controllers::JsonApi.method(:validate_query),
        Kit::JsonApi::Services::QueryResolver.method(:resolve),
        Kit::JsonApi::Services::QuerySerializer.method(:serialize),

        self.method(:load_and_render),
      ],
      ctx:  { request: request },
    })
  end

  Kit::Router::Services::Router.register(
    uid:     ROUTE_UID,
    aliases: [ROUTE_ID],
    target:  self.method(:endpoint),
  )

  def self.add_endpoint_json_api_query_data(json_api_query:)
    # TODO: add endpoint specific restrictions or defaults for the JsonApiQuery
    [:ok, json_api_query: json_api_query]
  end

  def self.tmp_create_query
    author_resource = Kit::JsonApiSpec::Resources::Author
    query_node      = {
      resource:      author_resource,
      relationships: {},
      filters:       [[]],
      ordering:      [[:id, :desc]],
      limit:         5,
      data:          nil,
      meta:          {},
    }

    json_api_query = {
      fields:     {
        Kit::JsonApiSpec::Resources::Author => author_resource[:available_fields].map(&:first),
      },
      entry_node: query_node,
    }

    [:ok, json_api_query: json_api_query]
  end

  # TODO: probably don't need this for access ?
  def self.load_and_render
    [:ok, {
      response: {
        mime:     :json_api,
        content:  { 'status' => 'success' }.to_json.to_s,
        metadata: {
          http: {
            status: 200,
          },
        },
      },
    },]
  end

end
