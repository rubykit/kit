module Kit::Auth::Actions::OauthAccessTokens::CreateForUserConfirmation

  def self.call(user:, oauth_application:)
    Kit::Auth::Actions::OauthAccessTokens::Create.call(
      user:                          user,
      oauth_application:             oauth_application,
      scopes:                        'user_confirmation',
      oauth_access_token_expires_in: 30.day,
    )
  end

end
