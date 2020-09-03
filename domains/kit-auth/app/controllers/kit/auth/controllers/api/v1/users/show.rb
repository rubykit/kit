module Kit::Auth::Controllers::Api::V1::Users
  module Show

    ROUTE_UID = 'kit_auth|api_v1|users|show'

    def self.endpoint(router_request:)
      Kit::Organizer.call({
        list: [
          Kit::Domain::Controllers::JsonApi.method(:ensure_media_type),
          :api_requires_current_user!,
          #[:api_load_resources!, { model: Kit::Auth::Models::Read::User, param: :id, }],

          ->(router_request:) do
            Kit::Auth::Controllers::Api.load_resource!(
              router_request: router_request,
              model:   Kit::Auth::Models::Read::User,
            )
          end,
          ->(resource:, current_user:) do
            Kit::Auth::Controllers::Api.require_belongs_to!(
              parent: current_user,
              child:  resource,
            )
          end,
          self.method(:render),
        ],
        ctx: { router_request: router_request, },
      })
    end

    Kit::Router::Services::Router.register(
      uid:     ROUTE_UID,
      aliases: [
        'api_v1|users|show',
        'api|users|show',
      ],
      target:  self.method(:endpoint),
    )

    def self.render(resource:)
      Kit::Router::Controllers::Http.render_jsonapi(
        resources:   resource,
        serializers: Kit::Auth::Controllers::Api.serializers,
        links: {
          self: Kit::Router::Services::Router.url(id: ROUTE_UID, params: { resource_id: resource.id }),
        },
      )
    end

  end
end