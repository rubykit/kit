module Kit::Auth::Controllers::Api::V1::AuthorizationTokens
  class IndexController < Kit::Auth::Controllers::Api::ApiV1Controller # :nodoc:

    ROUTE_UID = 'api_v1|authorization_tokens|index'

    Kit::Router.register(uid: ROUTE_UID, controller: self, action: :endpoint)

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
        prev: Kit::Router.path(uid: ROUTE_UID, params: pagination_params[:prev]),
        next: Kit::Router.path(uid: ROUTE_UID, params: pagination_params[:next]),
      }
    end

  end
end