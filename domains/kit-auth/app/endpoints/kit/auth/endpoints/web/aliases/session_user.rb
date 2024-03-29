# Common aliases for SessionUser
module Kit::Auth::Endpoints::Web::Aliases::SessionUser

  def self.require_session_user!(router_conn:, i18n_params: nil)
    if router_conn.metadata[:session_user]
      [:ok, session_user: router_conn.metadata[:session_user]]
    else
      Kit::Router::Adapters::Http::Intent::Actions::Save.call(
        router_conn: router_conn,
        intent_type: :user_auth,
      )

      i18n_params ||= {}

      Kit::Domain::Endpoints::Http.redirect_to(
        router_conn: router_conn,
        location:    Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|sign_in|new'),
        flash:       {
          alert: I18n.t('kit.auth.notifications.sign_in.required', **i18n_params),
        },
      )
    end
  end

  def self.redirect_if_session_user!(router_conn:, i18n_params: nil)
    return [:ok] if !router_conn.metadata[:session_user]

    i18n_params ||= {}

    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|sign_in|after'),
      flash:       {
        alert: I18n.t('kit.auth.notifications.sign_out.required', **i18n_params),
      },
    )
  end

  def self.redirect_if_session_missing_scope!(router_conn:, scope:, i18n_params: nil)
    model = router_conn.metadata[:session_user_access_token]
    if model
      model_scopes = Doorkeeper::OAuth::Scopes.from_string(model.scopes)
      return [:ok] if model_scopes.include?(scope.to_s)
    end

    i18n_params ||= {}

    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|sign_in|new'),
      flash:       {
        alert: I18n.t('kit.auth.notifications.scopes.missing', **i18n_params.merge(scopes: [scope])),
      },
    )
  end

  def self.register_aliases
    Kit::Organizer::Services::Callable::Alias.register(id: :kit_auth_web_require_session_user!, target: self.method(:require_session_user!))
    Kit::Organizer::Services::Callable::Alias.register(id: :web_require_session_user!,          target: self.method(:require_session_user!))

    Kit::Organizer::Services::Callable::Alias.register(id: :kit_auth_web_redirect_if_session_user!, target: self.method(:redirect_if_session_user!))
    Kit::Organizer::Services::Callable::Alias.register(id: :web_redirect_if_session_user!,          target: self.method(:redirect_if_session_user!))

    Kit::Organizer::Services::Callable::Alias.register(id: :kit_auth_web_redirect_if_session_missing_scope!, target: self.method(:redirect_if_session_missing_scope!))
    Kit::Organizer::Services::Callable::Alias.register(id: :web_redirect_if_session_missing_scope!,          target: self.method(:redirect_if_session_missing_scope!))
  end

end
