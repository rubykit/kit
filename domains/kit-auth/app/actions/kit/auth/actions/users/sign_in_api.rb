module Kit::Auth::Actions::Users::SignInApi

  def self.call(user:, router_conn:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::Applications::LoadApi,
        Kit::Auth::Actions::RequestMetadata::Create,
        Kit::Auth::Actions::AccessTokens::CreateForSignIn,
        Kit::Auth::Actions::AccessTokens::UpdateRequestMetadata,
      ],
      ctx:  {
        user:        user,
        router_conn: router_conn,
      },
    )
  end

end
