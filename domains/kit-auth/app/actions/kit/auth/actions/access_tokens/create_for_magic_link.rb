module Kit::Auth::Actions::AccessTokens::CreateForMagicLink

  def self.call(user:, application:)
    Kit::Auth::Actions::AccessTokens::Create.call(
      user:                    user,
      application:             application,
      scopes:                  Kit::Auth::Services::Scopes::USER_SIGN_IN,
      access_token_expires_in: 1.day,
    )
  end

end
