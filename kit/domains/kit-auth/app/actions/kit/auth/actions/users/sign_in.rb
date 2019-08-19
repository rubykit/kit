module Kit::Auth::Actions::Users::SignIn

  def self.call(user:, request:, oauth_application:)
    Kit::Organizer.call({
      ctx: {
        user:              user,
        request:           request,
        oauth_application: oauth_application,
      },
      list: [
        Kit::Auth::Actions::UserRequestMetadata::CreateUserRequestMetadata,
        Kit::Auth::Actions::OauthAccessTokens::CreateForSignIn,
        Kit::Auth::Actions::OauthAccessTokens::UpdateUserRequestMetadata,
      ],
    })
  end

end