module Kit::Auth::Actions::Users::SignInWeb

  def self.call(user:, request:)
    Kit::Organizer.call({
      ctx: {
        user:    user,
        request: request,
      },
      list: [
        Kit::Auth::Actions::OauthApplications::LoadWeb,
        Kit::Auth::Actions::Users::SignIn,
      ],
    })
  end

end