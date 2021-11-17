module Kit::Auth::Actions::Users::SignInWeb

  def self.call(user:, router_conn:, sign_in_method:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::Applications::LoadWeb,
        Kit::Auth::Actions::RequestMetadata::Create,
        Kit::Auth::Actions::AccessTokens::CreateForSignIn,
        Kit::Auth::Actions::AccessTokens::LinkRequestMetadata,
        self.method(:save_access_token_in_cookies),
        self.method(:send_event),

      ],
      ctx:  {
        user:           user,
        router_conn:    router_conn,
        sign_in_method: sign_in_method,
      },
    )
  end

  def self.save_access_token_in_cookies(router_conn:, access_token_plaintext_secret:)
    router_conn.response[:http][:cookies][:access_token] = { value: access_token_plaintext_secret, encrypted: true }

    [:ok, router_conn: router_conn]
  end

  def self.send_event(user:, sign_in_method:)
    Kit::Router::Services::Adapters.cast(
      route_id:     'event|user|auth|sign_in',
      adapter_name: :async,
      params:       {
        user_id:        user.id,
        sign_in_method: sign_in_method,
      },
    )

    [:ok]
  end

end
