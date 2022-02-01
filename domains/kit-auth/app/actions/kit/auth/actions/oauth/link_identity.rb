module Kit::Auth::Actions::Oauth::LinkIdentity

  def self.call(router_conn:, user:, omniauth_data:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Services::UserOauthIdentity.method(:create),
        Kit::Auth::Actions::RequestMetadata::Create,
        self.method(:send_event),
      ],
      ctx:  {
        router_conn:   router_conn,
        user:          user,
        omniauth_data: omniauth_data,
      },
    )
  end

  def self.send_event(user_oauth_identity:)
    Kit::Router::Services::Adapters.cast(
      route_id:     'event|users|oauth|linked',
      adapter_name: :async,
      params:       {
        user_oauth_identity_id: user_oauth_identity.id,
      },
    )

    [:ok]
  end

end
