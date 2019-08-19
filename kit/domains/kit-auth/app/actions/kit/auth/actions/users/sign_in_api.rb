module Kit::Auth::Actions::Users::SignInApi

  def self.call(user:, request:)
    Kit::Organizer.call({
      ctx: {
        user:    user,
        request: request,
      },
      list: [
        Kit::Auth::Actions::OauthApplications::LoadApi,
        Kit::Auth::Actions::Users::SignIn,
      ],
    })
  end

end