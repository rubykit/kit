module Kit::Auth::Controllers::Api::V1::AuthorizationTokens
  class IndexController < Kit::Auth::Controllers::Api::ApiV1Controller # :nodoc:

    ROUTE_ID  = 'api_v1|authorization_tokens|index'
    ROUTE_UID = "kit_auth|#{ROUTE_ID}"

    Kit::Router.register_rails_action(uid: ROUTE_UID, aliases: [ROUTE_ID, 'api|authorization_tokens|index'], controller: self, action: :endpoint)

    before_action *[
      :require_current_user!,
    ]

    def endpoint
      collection = Kit::Auth::Models::Read::OauthAccessToken
        .where(resource_owner_id: current_user.id)

      collection = paginate(relation: collection, ordering: PAGE_ORDERING)

      render({
        status: :ok,
        jsonapi: collection,
        class: {
          :'Kit::Auth::Models::Read::OauthAccessToken' => Kit::Auth::Serializers::AccessToken,
        },
      })
    end


    PAGE_ORDERING = [[:created_at, :desc], [:id, :desc]]

    def jsonapi_pagination(collection)
      pagination_params = get_pagination_parameters(collection: collection, ordering: PAGE_ORDERING)

      {
        prev: Kit::Router.url(id: ROUTE_UID, params: pagination_params[:prev]),
        next: Kit::Router.url(id: ROUTE_UID, params: pagination_params[:next]),
      }
    end

  end
end