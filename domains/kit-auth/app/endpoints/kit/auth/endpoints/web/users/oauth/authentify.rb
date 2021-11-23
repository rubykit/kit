module Kit::Auth::Endpoints::Web::Users::Oauth::Authentify

  # Redirect to Omniauth request route.
  #
  # Since Omniauth is a Rack middleware, Kit is never hit when we go through the endpoints directly.
  # This is an issue for saving intent, so this endpoint is in charge of handling intent & redirecting to the Omniauth request route.
  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      ok:    [
        [:alias, :web_resolve_current_user],
        self.method(:ensure_omniauth_provider),
        [:branch, ->(session_user:) { [session_user ? nil : :save_intent] }, {
          save_intent: [
            self.method(:save_intent),
          ],
        },],
        self.method(:redirect_to_omniauth_route),
      ],
      error: [
        Kit::Domain::Endpoints::Http.method(:redirect_with_errors),
      ],
      ctx:   { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|users|oauth|authentify',
    aliases: {
      'web|users|oauth|authentify' => [
        'web|users|oauth|sign_up',
        'web|users|oauth|sign_in',
      ],
    },
    target:  self.method(:endpoint),
  )

  def self.ensure_omniauth_provider(router_conn:)
    provider_external_name = router_conn[:params][:provider].to_sym

    provider = Kit::Auth::Services::Oauth.providers
      .select { |el| el[:group] == :web }
      .find   { |el| el[:external_name] == provider_external_name }

    if provider
      [:ok, omniauth_strategy: provider[:omniauth_strategy]]
    else
      i18n_params = {
        provider: provider_external_name,
      }

      [:error, { code: :oauth_provider_not_supported, detail: I18n.t('kit.auth.notifications.oauth.errors.provider_unsupported', **(i18n_params || {})) }]
    end
  end

  # Save the intent if any.
  #
  # Since the endpoint is used for different scenarios, so we try to recover the `intent_step` from the mountpoint if it has mot been explicitely provided.
  def self.save_intent(router_conn:, intent_step: nil)
    intent_step ||= router_conn.dig(:metadata, :config, :intent_step)
    intent_type = router_conn.request[:params][:intent]

    return [:ok] if !intent_step || !intent_type

    Kit::Auth::Actions::Intents::Save.call(
      router_conn: router_conn,
      intent_step: intent_step.to_sym,
      intent_type: intent_type.to_sym,
    )
  end

  def self.redirect_to_omniauth_route(router_conn:, omniauth_strategy:)
    redirect_url = Kit::Auth::Services::Oauth.omniauth_strategy_url(omniauth_strategy_name: omniauth_strategy)

    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    redirect_url,
    )
  end

end
