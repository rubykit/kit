module Kit::Auth::Actions::OauthAccessTokens::CreateForEmailConfirmation

  def self.call(user:, oauth_application:)
    Kit::Auth::Actions::OauthAccessTokens::Create.call(
      user:                          user,
      oauth_application:             oauth_application,
      scopes:                        Kit::Auth::Services::Scopes::USER_EMAIL_CONFIRMATION,
      oauth_access_token_expires_in: 30.day,
    )
  end

end
