module Kit::Auth::Helpers
  module CurrentUserOauthAccessTokenHelper

    def current_user_oauth_access_token
      request.instance_variable_get(:@current_user_oauth_access_token)
    end

  end
end