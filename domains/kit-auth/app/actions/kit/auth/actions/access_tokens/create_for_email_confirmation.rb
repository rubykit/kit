module Kit::Auth::Actions::AccessTokens::CreateForEmailConfirmation

  def self.call(user:, application:, user_email:)
    Kit::Auth::Actions::AccessTokens::Create.call(
      user:                    user,
      application:             application,
      scopes:                  Kit::Auth::Services::Scopes::USER_EMAIL_CONFIRMATION,
      access_token_expires_in: 7.day,
      extra:                   {
        user_email_id: user_email.id,
      },
    )
  end

end
