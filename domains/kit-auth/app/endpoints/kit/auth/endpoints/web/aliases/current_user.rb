module Kit::Auth::Endpoints::Web::Aliases::CurrentUser

  def self.resolve_current_user(router_conn:)
    if !router_conn.metadata[:current_user_resolved]
      _, ctx = Kit::Organizer.call(
        ok:  [
          Kit::Auth::Actions::Applications::LoadWeb,
          Kit::Auth::Actions::Users::IdentifyUserForConn,
        ],
        ctx: {
          router_conn: router_conn,
        },
      )

      router_conn = ctx[:router_conn]
    end

    [:ok,
      router_conn:               router_conn,

      session_user:              router_conn.metadata[:session_user],
      session_user_access_token: router_conn.metadata[:session_user_access_token],

      request_user:              router_conn.metadata[:request_user],
      request_user_access_token: router_conn.metadata[:request_user_access_token],
    ]
  end

  def self.register_aliases
    Kit::Organizer::Services::Callable::Alias.register(id: :kit_auth_web_resolve_current_user, target: self.method(:resolve_current_user))
    Kit::Organizer::Services::Callable::Alias.register(id: :web_resolve_current_user,          target: self.method(:resolve_current_user))
  end

end
