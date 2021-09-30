module Kit::Auth::Controllers::Api::SessionUser

  METADATA_KEY_CURRENT_USER                    = :api_session_user
  METADATA_KEY_CURRENT_USER_OAUTH_ACCESS_TOKEN = :api_session_user_access_token
  METADATA_KEY_CURRENT_USER_ATTEMPTED_RESOLVED = :api_session_user_attempted_resolved

  def self.session_user(router_conn:)
    router_conn.metadata[METADATA_KEY_CURRENT_USER]
  end

  def self.session_user_access_token(router_conn:)
    router_conn.metadata[METADATA_KEY_CURRENT_USER_OAUTH_ACCESS_TOKEN]
  end

  def self.requires_session_user!(router_conn:)
    api_resolve_current_user(router_conn: router_conn)

    if (model = session_user(router_conn: router_conn))
      return [:ok, session_user: model]
    end

    Kit::Auth::Controllers::Api.render_unauthorized
  end

  Kit::Organizer::Services::Callable::Alias.register(id: :api_requires_session_user!, target: self.method(:requires_session_user!))

  def self.requires_scope!(router_conn:, scope:)
    api_resolve_current_user(router_conn: router_conn)

    if (model = session_user_access_token(router_conn: router_conn))
      model_scopes = OAuth::Scopes.from_string(model.scopes)
      return [:ok] if model_scopes.includes?(scope)
    end

    Kit::Auth::Controllers::Api.render_forbidden
  end

  Kit::Organizer::Services::Callable::Alias.register(id: :api_requires_scope!, target: self.method(:requires_scope!))

  def self.resolve_current_user(router_conn:)
    if !router_conn.metadata[METADATA_KEY_CURRENT_USER_ATTEMPTED_RESOLVED]
      status, ctx = Kit::Organizer.call(
        list: [
          Kit::Auth::Actions::Applications::LoadApi,
          [:local_ctx, Kit::Auth::Actions::Users::IdentifyUserForConn, { allow: [:param, :header] }],
        ],
        ctx:  {
          router_conn: router_conn,
        },
      )

      router_conn.metadata[METADATA_KEY_CURRENT_USER_ATTEMPTED_RESOLVED] = true

      if status == :ok
        router_conn.metadata[METADATA_KEY_CURRENT_USER]                    = ctx[:user]
        router_conn.metadata[METADATA_KEY_CURRENT_USER_OAUTH_ACCESS_TOKEN] = ctx[:access_token]
      end
    end

    [:ok,
      session_user:              session_user(router_conn: router_conn),
      session_user_access_token: session_user_access_token(router_conn: router_conn),
    ]
  end

  Kit::Organizer::Services::Callable::Alias.register(id: :api_resolve_current_user, target: self.method(:resolve_current_user))

end
