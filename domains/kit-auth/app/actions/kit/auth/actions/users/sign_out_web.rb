module Kit::Auth::Actions::Users::SignOutWeb

  def self.call(router_conn:, access_token:)
    Kit::Organizer.call(
      list: [
        self.method(:clear_access_token_cookies),
        self.method(:send_event),
      ],
      ctx:  {
        router_conn:  router_conn,
        access_token: access_token,
      },
    )
  end

  def self.clear_access_token_cookies(router_conn:)
    router_conn.response[:http][:cookies][:access_token] = { value: nil, encrypted: true, delete: true }

    [:ok, router_conn: router_conn]
  end

  def self.send_event(access_token:)
    Kit::Router::Services::Adapters.cast(
      route_id:     'event|users|auth|sign_out',
      adapter_name: :async,
      params:       {
        user_id:        access_token.user_id,
        user_secret_id: access_token.id,
      },
    )

    [:ok]
  end

end
