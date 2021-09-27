module Kit::Auth::Actions::AccessTokens::CreateForPasswordReset

  def self.call(user:, application:)
    Kit::Auth::Actions::AccessTokens::Create.call(
      user:                    user,
      application:             application,
      scopes:                  Kit::Auth::Services::Scopes::USER_PASSWORD_UPDATE,
      access_token_expires_in: 1.day,
    )
  end

end
