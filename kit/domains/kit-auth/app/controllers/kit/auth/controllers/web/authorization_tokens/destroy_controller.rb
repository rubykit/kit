module Kit::Auth::Controllers::Web::AuthorizationTokens
  class DestroyController < Kit::Auth::Controllers::WebController

=begin
    ROUTE_ID  = 'web|authorization_tokens|destroy'
    ROUTE_UID = "kit_auth|#{ROUTE_ID}"

    Kit::Router.register_rails_action(uid: ROUTE_UID, aliases: [ROUTE_ID, 'web|users|sign_out'], controller: self, action: :destroy)

    def destroy
      if current_user_oauth_access_token
        Kit::Auth::Services::OauthAccessToken.revoke({ oauth_access_token: current_user_oauth_access_token })

        cookies.encrypted[:access_token] = nil
      end

      redirect_to Kit::Router.path(id: 'web|users|sign_in')
    end
=end

  end
end