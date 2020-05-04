module Kit::Auth::Controllers::Api::V1::AuthorizationTokens
  module Index

    ROUTE_ID  = 'api_v1|authorization_tokens|index'
    ROUTE_UID = "kit_auth|#{ROUTE_ID}"

    def self.endpoint(request:)
      Kit::Organizer.call({
        list: [
          Kit::Domain::Controllers::JsonApi.method(:ensure_media_type),
          :api_requires_current_user!,
          self.method(:load_and_render),
        ],
        ctx: { request: request, },
      })
    end

    Kit::Router::Services::Router.register(
      uid:     ROUTE_UID,
      aliases: [
        ROUTE_ID,
        'api|authorization_tokens|index',
      ],
      target:  self.method(:endpoint),
    )

    PAGE_ORDERING = [[:created_at, :desc], [:id, :desc]]

    def self.load_and_render(current_user:)
      resources = Kit::Auth::Models::Read::OauthAccessToken
        .where(resource_owner_id: current_user.id)

      # NOTE: can we use `tap` for this?
      resources = Kit::Auth::Controllers::Api.paginate(relation: resources, ordering: PAGE_ORDERING)

      pagination_params = Kit::Auth::Controllers::Api.get_pagination_parameters(collection: resources, ordering: PAGE_ORDERING)

      Kit::Router::Controllers::Http.render_jsonapi(
        resources:   resources,
        serializers: Kit::Auth::Controllers::Api.serializers,
        links: {
          prev: Kit::Router::Services::Router.url(id: ROUTE_UID, params: pagination_params[:prev]),
          next: Kit::Router::Services::Router.url(id: ROUTE_UID, params: pagination_params[:next]),
        },
      )
    end

  end
end