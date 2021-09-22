module Kit::Auth::Controllers::Api::CurrentUser

  METADATA_KEY_CURRENT_USER                    = :api_current_user
  METADATA_KEY_CURRENT_USER_OAUTH_ACCESS_TOKEN = :api_current_user_oauth_access_token
  METADATA_KEY_CURRENT_USER_ATTEMPTED_RESOLVED = :api_current_user_attempted_resolved

  def self.current_user(router_conn:)
    router_conn.metadata[METADATA_KEY_CURRENT_USER]
  end

  def self.current_user_oauth_access_token(router_conn:)
    router_conn.metadata[METADATA_KEY_CURRENT_USER_OAUTH_ACCESS_TOKEN]
  end

  def self.requires_current_user!(router_conn:)
    api_resolve_current_user(router_conn: router_conn)

    if (model = current_user(router_conn: router_conn))
      return [:ok, current_user: model]
    end

    Kit::Auth::Controllers::Api.render_unauthorized
  end

  Kit::Organizer::Services::Callable::Alias.register(id: :api_requires_current_user!, target: self.method(:requires_current_user!))

  def self.requires_scope!(router_conn:, scope:)
    api_resolve_current_user(router_conn: router_conn)

    if (model = current_user_oauth_access_token(router_conn: router_conn))
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
          Kit::Auth::Actions::OauthApplications::LoadApi,
          [:local_ctx, Kit::Auth::Actions::Users::IdentifyUserForConn, { allow: [:param, :header] }],
        ],
        ctx:  {
          router_conn: router_conn,
        },
      )

      router_conn.metadata[METADATA_KEY_CURRENT_USER_ATTEMPTED_RESOLVED] = true

      if status == :ok
        router_conn.metadata[METADATA_KEY_CURRENT_USER]                    = ctx[:user]
        router_conn.metadata[METADATA_KEY_CURRENT_USER_OAUTH_ACCESS_TOKEN] = ctx[:oauth_access_token]
      end
    end

    [:ok,
      current_user:                    current_user(router_conn: router_conn),
      current_user_oauth_access_token: current_user_oauth_access_token(router_conn: router_conn),
    ]
  end

  Kit::Organizer::Services::Callable::Alias.register(id: :api_resolve_current_user, target: self.method(:resolve_current_user))

end
