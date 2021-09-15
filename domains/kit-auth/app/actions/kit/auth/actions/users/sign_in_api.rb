module Kit::Auth::Actions::Users::SignInApi

  def self.call(user:, router_conn:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::OauthApplications::LoadApi,
        Kit::Auth::Actions::RequestMetadata::Create,
        Kit::Auth::Actions::OauthAccessTokens::CreateForSignIn,
        Kit::Auth::Actions::OauthAccessTokens::UpdateRequestMetadata,
      ],
      ctx:  {
        user:        user,
        router_conn: router_conn,
      },
    )
  end

end
