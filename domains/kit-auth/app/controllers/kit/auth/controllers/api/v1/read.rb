require_relative '../../../../../config/initializers/api_config'

# TODO: tmp, make this dynamic
KIT_API_CONFIG = Kit::Api::Services::Config.create_config({
  resources:     {
    user:       Kit::Auth::Resources::User.to_h,
    auth_token: Kit::Auth::Resources::AuthToken.to_h,
  },
  page_size:     3,
  page_size_max: 5,
  meta:          {
    kit_api_paginator_cursor: {
      encrypt_secret: '72b035a267ac10c7b5e3c0893c395ab0',
    },
  },
})

module Kit::Auth::Controllers::Api::V1::Read # rubocop:disable Style/Documentation

  # Generic `Json:Api` endpoint that works for `show` & `index` requests.
  def self.endpoint_read(router_request:, top_level_resource:, singular:)
    api_request = {
      config:             KIT_API_CONFIG,
      top_level_resource: top_level_resource,
      singular:           singular,
    }

    Kit::Organizer.call({
      list: [
        Kit::Api::JsonApi::Controllers::JsonApi.method(:ensure_media_type),
        Kit::Api::JsonApi::Services::Request::Import.method(:import),
        Kit::Api::Services::QueryBuilder.method(:build_query),
        Kit::Api::Services::QueryResolver.method(:resolve_query_node),
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

  # Register endpoints with the router for all Resources.
  KIT_API_CONFIG[:resources].each do |_resource_name, resource_object|
    routes = [
      { route_type: :index, singular: false },
      { route_type: :show,  singular: true  },
    ]

    routes.each do |route_type:, singular:|
      route_id  = "api|#{ resource_object[:name] }|#{ route_type }"
      route_uid = "kit_auth|#{ route_id }"
      route_fn  = ->(router_request:) do
        endpoint_read(
          router_request:     router_request,
          top_level_resource: resource_object,
          singular:           singular,
        )
      end

      Kit::Router::Services::Router.register(
        uid:     route_uid,
        aliases: [route_id],
        target:  route_fn,
      )
    end
  end

end
