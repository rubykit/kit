module Kit::Auth::Actions::Oauth::UnlinkIdentity

  def self.call(router_conn:, user_oauth_identity:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Services::UserOauthIdentity.method(:destroy),
        Kit::Auth::Actions::RequestMetadata::Create,
        self.method(:send_event),
      ],
      ctx:  {
        router_conn:         router_conn,
        user_oauth_identity: user_oauth_identity,
        user:                user_oauth_identity.user,
      },
    )
  end

  def self.send_event(user_oauth_identity:)
    Kit::Router::Services::Adapters.cast(
      route_id:     'event|user|oauth|unlinked',
      adapter_name: :async,
      params:       {
        user_id:                user_oauth_identity.user_id,
        user_oauth_identity_id: user_oauth_identity.id,
        provider:               user_oauth_identity.provider,
        provider_uid:           user_oauth_identity.provider_uid,
      },
    )

    [:ok]
  end

end
