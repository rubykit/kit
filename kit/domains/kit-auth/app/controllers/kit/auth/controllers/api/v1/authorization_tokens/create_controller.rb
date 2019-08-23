module Kit::Auth::Controllers::Api::V1::AuthorizationTokens
  class CreateController < Kit::Auth::Controllers::Api::ApiV1Controller # :nodoc:

    ROUTE_ID  = 'api_v1|authorization_tokens|create'
    ROUTE_UID = "kit_auth|#{ROUTE_ID}"

    Kit::Router.register_rails_action(uid: ROUTE_UID, aliases: [ROUTE_ID, 'api|authorization_tokens|create'], controller: self, action: :endpoint)

    def endpoint
      attributes = params[:authorization_token][:data][:attributes]

      context = {
        user:              attributes[:uid],
        password:          attributes[:secret],
        request:           request,
        oauth_application: ::Doorkeeper::Application.find_by!(uid: 'api'),
      }

      res, ctx = Kit::Organizer.call({
        ctx: context,
        list: [
          ->(email:) { [:ok, user: Kit::Auth::Models::Read::User.find_by(email: email)] },
          Kit::Auth::Actions::Users::VerifyPassword,
          Kit::Auth::Actions::RequestMetadata::Create,
          Kit::Auth::Actions::OauthAccessTokens::Create,
          Kit::Auth::Actions::OauthAccessTokens::UpdateRequestMetadata,
        ],
      })

      if res == :ok
        token = ctx[:oauth_access_token].to_read_record
        status_code = ctx[:oauth_access_token_created] ? 201 : 200
        render({
          status:  status_code,
          jsonapi: token,
          class: {
            :'Kit::Auth::Models::Read::OauthAccessToken' => Kit::Auth::Serializers::AccessToken,
          },
        })
      else
        render({
          jsonapi_errors: ctx,
        })
      end
    end

  end
end