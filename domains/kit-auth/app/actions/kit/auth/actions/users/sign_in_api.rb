module Kit::Auth::Actions::Users::SignInApi

  def self.call(user:, router_request:)
    Kit::Organizer.call({
      ctx: {
        user:    user,
        router_request: router_request,
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