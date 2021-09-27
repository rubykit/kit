module Kit::Auth::Actions::AccessTokens::CreateForEmailConfirmation

  def self.call(user:, application:)
    Kit::Auth::Actions::AccessTokens::Create.call(
      user:                    user,
      application:             application,
      scopes:                  Kit::Auth::Services::Scopes::USER_EMAIL_CONFIRMATION,
      access_token_expires_in: 30.day,
    )
  end

end
