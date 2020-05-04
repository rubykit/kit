module Kit::Auth::Actions::Users::SignInApi

  def self.call(user:, request:)
    Kit::Organizer.call({
      ctx: {
        user:    user,
        request: request,
      },
      list: [
        Kit::Auth::Actions::OauthApplications::LoadApi,
        Kit::Auth::Actions::RequestMetadata::Create,
        Kit::Auth::Actions::OauthAccessTokens::CreateForSignIn,
        Kit::Auth::Actions::OauthAccessTokens::UpdateRequestMetadata,
      ],
    })
  end

end