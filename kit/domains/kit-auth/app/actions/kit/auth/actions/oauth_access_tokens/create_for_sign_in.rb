module Kit::Auth::Actions::OauthAccessTokens::CreateForSignIn

  def self.call(user:, oauth_application:)
    Kit::Auth::Actions::OauthAccessTokens::Create.call({
      user:                          user,
      oauth_application:             oauth_application,
      scopes:                        ['public'],
      oauth_access_token_expires_in: 30.day,
    })
  end

end