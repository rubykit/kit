module Kit::Auth::Controllers::Web::CurrentUser

  def self.require_current_user!(router_conn:)
    return [:ok, current_user: router_conn.metadata[:current_user]] if router_conn.metadata[:current_user]

    Kit::Router::Controllers::Http.redirect_to(
      router_conn: router_conn,
      location:    Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|sign_in'),
      alert:       'This page requires you to be signed-in.',
    )
  end

  Kit::Organizer::Services::Callable::Alias.register(id: :web_require_current_user!, target: self.method(:require_current_user!))

  def self.redirect_if_current_user!(router_conn:)
    return [:ok] if !router_conn.metadata[:current_user]

    Kit::Router::Controllers::Http.redirect_to(
      router_conn: router_conn,
      location:    Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|sign_in|after'),
      alert:       'This page requires you to be signed-out.',
    )
  end

  Kit::Organizer::Services::Callable::Alias.register(id: :web_redirect_if_current_user!, target: self.method(:redirect_if_current_user!))

  def self.redirect_if_missing_scope!(router_conn:, scope:)
    model = router_conn.metadata[:current_user_oauth_access_token]
    if model
      model_scopes = Doorkeeper::OAuth::Scopes.from_string(model.scopes)
      return [:ok] if model_scopes.include?(scope.to_s)
    end

    Kit::Router::Controllers::Http.redirect_to(
      router_conn: router_conn,
      location:    Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|sign_in'),
      alert:       "Missing scope: #{ scope }",
    )
  end

  Kit::Organizer::Services::Callable::Alias.register(id: :web_redirect_if_missing_scope!, target: self.method(:redirect_if_missing_scope!))

  def self.resolve_current_user(router_conn:)
    if !router_conn.metadata[:current_user_resolved]
      status, ctx = Kit::Organizer.call(
        list: [
          Kit::Auth::Actions::OauthApplications::LoadWeb,
          Kit::Auth::Actions::Users::IdentifyUserForConn,
        ],
        ctx:  {
          router_conn: router_conn,
        },
      )

      router_conn.metadata[:current_user_resolved] = true

      if status == :ok
        router_conn.metadata[:current_user]                    = ctx[:user]
        router_conn.metadata[:current_user_oauth_access_token] = ctx[:oauth_access_token]
      end
    end

    [:ok,
      current_user:                    router_conn.metadata[:current_user],
      current_user_oauth_access_token: router_conn.metadata[:current_user_oauth_access_token],
    ]
  end

  Kit::Organizer::Services::Callable::Alias.register(id: :web_resolve_current_user, target: self.method(:resolve_current_user))

end
