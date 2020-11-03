module Kit::Auth::Controllers::Api::V1::Users
  module Show

    ROUTE_ID  = 'api_v1|users|show'
    ROUTE_UID = "kit_auth|#{ ROUTE_ID }"

    def self.endpoint(router_request:)
      Kit::Organizer.call({
        list: [
          #Kit::Domain::Controllers::JsonApi.method(:ensure_media_type),
          #[:alias, :api_requires_current_user!],
          #[:api_load_resources!, { model: Kit::Auth::Models::Read::User, param: :id, }],

          ->(router_request:) do # rubocop:disable Lint/ShadowingOuterLocalVariable
            Kit::Auth::Controllers::Api.load_resource!(
              router_request: router_request,
              model:          Kit::Auth::Models::Read::User,
            )
          end,
=begin
          ->(resource:, current_user:) do
            Kit::Auth::Controllers::Api.require_belongs_to!(
              parent: current_user,
              child:  resource,
            )
          end,
=end
          self.method(:render),
        ],
        ctx:  { router_request: router_request },
      })
    end

    Kit::Router::Services::Router.register(
      uid:     ROUTE_UID,
      aliases: {
        ROUTE_ID => 'api|users|show',
      },
      target:  self.method(:endpoint),
    )

    def self.render(resource:)
      Kit::Router::Controllers::Http.render_jsonapi(
        resources:   resource,
        serializers: Kit::Auth::Controllers::Api.serializers,
        links:       {
          self: Kit::Router::Services::Adapters::Http::Mountpoints.path(id: ROUTE_ID, params: { resource_id: resource.id }),
        },
      )
    end

  end
end
