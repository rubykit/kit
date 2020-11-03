module Kit::Auth::Controllers::Api::V1::Users
  module Create

    ROUTE_ID  = 'api_v1|users|create'
    ROUTE_UID = "kit_auth|#{ ROUTE_ID }"

    def self.endpoint(router_request:)
      status, ctx = Kit::Organizer.call({
        list: [
          Kit::Domain::Controllers::JsonApi.method(:ensure_media_type),
          Kit::Auth::Actions::Users::CreateUserWithPassword,
          self.method(:render),
        ],
        ctx:  router_request.params.slice(:email, :password, :password_confirmation),
      })

      if status == :ok
        [status, ctx]
      else
        Kit::Router::Controllers::Http.render_jsonapi_errors(
          resources: ctx[:errors],
        )
      end
    end

    Kit::Router::Services::Router.register(
      uid:     ROUTE_UID,
      aliases: {
        ROUTE_ID => 'api|users|create',
      },
      target:  self.method(:endpoint),
    )

    def self.render(user:)
      Kit::Router::Controllers::Http.render_jsonapi(
        status:      201,
        resources:   user,
        serializers: Kit::Auth::Controllers::Api.serializers,
        links:       {
          self: Kit::Router::Services::Adapters::Http::Mountpoints.path(id: ROUTE_UID, params: { resource_id: user.id }),
        },
      )
    end

  end
end
