module Kit::Auth::Actions::Users::SignInWeb

  def self.call(user:, router_request:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::OauthApplications::LoadWeb,
        Kit::Auth::Actions::RequestMetadata::Create,
        Kit::Auth::Actions::OauthAccessTokens::CreateForSignIn,
        Kit::Auth::Actions::OauthAccessTokens::UpdateRequestMetadata,
        Kit::Auth::Actions::Users::SignInWeb.method(:send_event),
      ],
      ctx:  {
        user:           user,
        router_request: router_request,
      },
    )
  end

  def self.send_event(user:)
    Kit::Router::Services::Adapters.cast(
      route_id:     'event|user|auth|sign_in',
      adapter_name: :async,
      params:       {
        user: user,
        type: 'email',
      },
    )

    [:ok]
  end

end
