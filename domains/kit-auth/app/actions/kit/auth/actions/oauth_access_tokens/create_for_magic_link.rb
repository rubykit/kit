module Kit::Auth::Actions::OauthAccessTokens::CreateForMagicLink

  def self.call(user:, oauth_application:)
    Kit::Auth::Actions::OauthAccessTokens::Create.call(
      user:                          user,
      oauth_application:             oauth_application,
      scopes:                        Kit::Auth::Services::Scopes::USER_SIGN_IN,
      oauth_access_token_expires_in: 1.day,
    )
  end

end
