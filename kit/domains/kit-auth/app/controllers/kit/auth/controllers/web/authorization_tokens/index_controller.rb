module Kit::Auth::Controllers::Web::AuthorizationTokens
  class IndexController < Kit::Auth::Controllers::WebController

    ROUTE_ID  = 'web|authorization_tokens|index'
    ROUTE_UID = "kit_auth|#{ROUTE_ID}"

    Kit::Router.register(uid: ROUTE_UID, aliases: [ROUTE_ID], controller: self, action: :index)

    before_action *[
      :require_current_user!,
    ]

    def index
      list = Kit::Auth::Models::Read::OauthAccessToken
        .where('revoked_at IS NULL')
        .where("(created_at + expires_in * INTERVAL '1 second') > ?", DateTime.now)
        .where(resource_owner_id: current_user.id)
        .preload(:last_user_request_metadata)
        .load

      list = list.map do |model|
        user_request_metadata = model.last_user_request_metadata
        country = nil
        if user_request_metadata
          country = Kit::Auth::Models::Read::IpGeolocation
            .where('ip_start <= ?', user_request_metadata.ip.to_s)
            .where('ip_end   >= ?', user_request_metadata.ip.to_s)
            .first
            &.country
        end

        {
          oauth_access_token:    model.attributes&.symbolize_keys,
          user_request_metadata: user_request_metadata&.attributes&.symbolize_keys,
          country:               country&.attributes&.symbolize_keys,
        }
      end

      render :index, locals: { list: list }
    end

  end
end