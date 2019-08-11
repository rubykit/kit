module Kit::Auth::Controllers::Api::V1::AuthorizationTokens
  class CreateController < Kit::Auth::Controllers::Api::ApiV1Controller # :nodoc:

    ROUTE_UID = 'api_v1|authorization_tokens|create'

    Kit::Router.register(uid: ROUTE_UID, controller: self, action: :endpoint)

    def endpoint
      attributes = params[:authorization_token][:data][:attributes]

      context = {
        email:             attributes[:uid],
        password:          attributes[:secret],
        request:           request,
        oauth_application: ::Doorkeeper::Application.find_by!(uid: 'api'),
      }

      res, ctx = Kit::Organizer.call({
        ctx: context,
        list: [
          Kit::Auth::Actions::Users::VerifyUserWithPassword,
          Kit::Auth::Actions::Users::CreateUserRequestMetadata,
          Kit::Auth::Actions::Users::GetAuthorizationTokenForUser,
          Kit::Auth::Actions::Users::UpdateUamForAuthorizationToken,
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