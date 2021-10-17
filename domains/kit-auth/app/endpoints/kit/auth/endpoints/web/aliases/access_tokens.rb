# Common aliases for RequestUser
module Kit::Auth::Endpoints::Web::Aliases::AccessTokens

  def self.redirect_if_missing_scope!(router_conn:, access_token:, scope:, i18n_params: nil)
    model_scopes = Doorkeeper::OAuth::Scopes.from_string(access_token.scopes)
    return [:ok] if model_scopes.include?(scope.to_s)

    i18n_params ||= {}

    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|sign_in'),
      flash:       {
        alert: I18n.t('kit.auth.notifications.scopes.missing', **i18n_params.merge(scopes: [scope])),
      },
    )
  end

  Kit::Organizer::Services::Callable::Alias.register(id: :web_redirect_if_missing_scope!, target: self.method(:redirect_if_missing_scope!))

end
