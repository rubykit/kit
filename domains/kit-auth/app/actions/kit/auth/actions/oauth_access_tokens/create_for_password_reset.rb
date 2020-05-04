module Kit::Auth::Actions::OauthAccessTokens::CreateForPasswordReset

  def self.call(user:, oauth_application:)
    Kit::Auth::Actions::OauthAccessTokens::Create.call({
      user:                          user,
      oauth_application:             oauth_application,
      scopes:                        'user_update_password',
      oauth_access_token_expires_in: 1.day,
    })
  end

end