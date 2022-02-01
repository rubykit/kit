module Kit::Auth::Actions::Users::RevokeAccessToken

  def self.call(router_conn:, access_token:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Services::AccessToken.method(:revoke),
        self.method(:send_event),
      ],
      ctx:  {
        router_conn:  router_conn,
        access_token: access_token,
      },
    )
  end

  def self.send_event(access_token:)
    Kit::Router::Services::Adapters.cast(
      route_id:     'event|users|auth|access_token|revoked',
      adapter_name: :async,
      params:       {
        user_id:        access_token.user_id,
        user_secret_id: access_token.id,
      },
    )

    [:ok]
  end

end
