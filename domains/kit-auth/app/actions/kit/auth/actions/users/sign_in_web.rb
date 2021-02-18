module Kit::Auth::Actions::Users::SignInWeb

  def self.call(user:, router_request:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::OauthApplications::LoadWeb,
        Kit::Auth::Actions::RequestMetadata::Create,
        Kit::Auth::Actions::OauthAccessTokens::CreateForSignIn,
        Kit::Auth::Actions::OauthAccessTokens::UpdateRequestMetadata,
      ],
      ctx:  {
        user:           user,
        router_request: router_request,
      },
    )
  end

end
