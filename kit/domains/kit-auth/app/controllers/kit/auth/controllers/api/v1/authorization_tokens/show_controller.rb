module Kit::Auth::Controllers::Api::V1::AuthorizationTokens
  class ShowController < Kit::Auth::Controllers::Api::ApiV1Controller # :nodoc:

    ROUTE_ID  = 'api_v1|authorization_tokens|show'
    ROUTE_UID = "kit_auth|#{ROUTE_ID}"

    Kit::Router.register_rails_action(uid: ROUTE_UID, aliases: [ROUTE_ID, 'api|authorization_tokens|show'], controller: self, action: :endpoint)

    before_action *[
      :require_current_user!,
      -> { load_resource!(model: Kit::Auth::Models::Read::OauthAccessToken, param: :resource_id) },
      -> { require_belongs_to!(parent: current_user, child: resource) },
    ]

    def endpoint
      render({
        status: :ok,
        jsonapi: resource,
        class: {
          :'Kit::Auth::Models::Read::OauthAccessToken' => Kit::Auth::Serializers::AccessToken,
        },
      })
    end

  end
end