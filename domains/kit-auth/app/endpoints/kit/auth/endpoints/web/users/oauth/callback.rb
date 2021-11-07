# TODO: write better doc!
# TODO: cleanup redirect strategies && add aliases.
module Kit::Auth::Endpoints::Web::Users::Oauth::Callback

  # Omniauth callback endpoint.
  #
  # Since this is being hit after a redirect by the Omniauth middleware, we have no context on what the user initial intent was.
  # (If we wanted to achieve this we would need to use cookies or store (redis, memcached, etc) backed sessions).
  # In the meantime this is not really an issue, we can figure out what the best flow is.
  #
  # We have two high level scenarios when this endpoint is reached:
  #   - User is signed-in
  #   - User is signed-out
  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      ok:    [
        [:alias, :web_resolve_current_user],
        self.method(:ensure_omniauth_data),
        self.method(:load_user_oauth_identity),
        [:branch, ->(session_user:) { [session_user ? :signed_in : :signed_out] }, {
          signed_in:  [self.method(:signed_in)],
          signed_out: [self.method(:signed_out)],
        },],
      ],
      error: [
        -> { [:ok, redirect_url: Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|home')] },
        Kit::Domain::Endpoints::Http.method(:redirect_with_errors),
      ],
      ctx:   { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|users|oauth|callback',
    aliases: ['web|users|oauth|callback'],
    target:  self.method(:endpoint),
  )

  # When the User is already signed-in:
  #   1a. Existing UserOauthIdentity:
  #     1a1. Different user on UAI & Session: ERROR_OUT
  #   1b. No existing UserOauthIdentity:
  #     1b1. Same email on session_user OR no user with provider_email: ASSOCIATE
  #     1b2. Email on another User: simplest strategy: ERROR_OUT
  def self.signed_in(router_conn:, omniauth_data:, user_oauth_identity:, session_user:)
    Kit::Organizer.call(
      ok:  [
        [:branch, ->(user_oauth_identity:) { [user_oauth_identity ? :has_identity : :no_identity] }, {
          has_identity: [
            self.method(:redirect_if_mismatch_identity_users!),
            [:local_ctx, self.method(:associate), { user: session_user }],
            # TODO: cleanup redirect strategiy && add alias
            -> { [:ok, location: Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|home')] },
            Kit::Domain::Endpoints::Http.method(:redirect_to),
          ],
          no_identity:  [
            self.method(:redirect_if_mismatch_users!),
            [:local_ctx, self.method(:associate), { user: session_user }],
            self.method(:redirect_to_settings),
          ],
        },],
      ],
      ctx: {
        router_conn:         router_conn,
        omniauth_data:       omniauth_data,
        user_oauth_identity: user_oauth_identity,
        session_user:        session_user,
      },
    )
  end

  # 2. User is signed-out:
  #   2a. Existing UAI: SIGN_IN
  #   2b. Non existing UAI:
  #     2b1. User with provider_email: ASSOCIATE && SIGN_IN
  #     2b2. No user: SIGN_UP
  def self.signed_out(router_conn:, omniauth_data:, user_oauth_identity:)
    Kit::Organizer.call(
      ok:    [
        Kit::Auth::Services::UserEmail.method(:find_user_by_email),
        self.method(:associate),
        self.method(:create_sign_in),
        Kit::Auth::Endpoints::Web::Users::SignIn::WithPassword::Create.method(:redirect),
      ],
      error: [
        self.method(:create_sign_up),
        self.method(:associate),
        self.method(:create_sign_in),
        Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::Create.method(:redirect),
      ],
      ctx:   {
        router_conn:         router_conn,
        omniauth_data:       omniauth_data,
        user_oauth_identity: user_oauth_identity,
        email:               router_conn.metadata[:oauth][:info][:email],
      },
    )
  end

  def self.ensure_omniauth_data(router_conn:)
    omniauth_data     = router_conn.metadata[:oauth]
    omniauth_strategy = omniauth_data&.dig(:provider)&.to_sym

    provider = Kit::Auth::Services::Oauth.providers
      .find { |el| el[:omniauth_strategy] == omniauth_strategy && el[:group] == :web }

    if !provider
      [:error, { code: :unknown_oauth_provider, detail: "Could not find the OAuth provider for `#{ omniauth_strategy }`" }]
    else
      omniauth_data[:omniauth_strategy] = provider[:omniauth_strategy]
      omniauth_data[:oauth_provider]    = provider[:internal_name]

      [:ok, omniauth_data: omniauth_data]
    end
  end

  def self.load_user_oauth_identity(omniauth_data:)
    model_instance = Kit::Auth::Models::Read::UserOauthIdentity.find_by(provider: omniauth_data[:oauth_provider], provider_uid: omniauth_data[:uid])

    [:ok, user_oauth_identity: model_instance]
  end

  def self.redirect_if_mismatch_users!(router_conn:, omniauth_data:, session_user:)
    email       = omniauth_data[:info][:email]
    status, ctx = Kit::Auth::Services::UserEmail.find_user_by_email(email: email)

    i18n_params = {
      provider:       user_oauth_identity.provider,
      provider_email: email,
    }.merge(i18n_params || {})

    if status == :error || ctx[:user].id == session_user.id
      [:ok]
    else
      Kit::Domain::Endpoints::Http.redirect_to(
        router_conn: router_conn,
        # TODO: cleanup redirect strategiy && add alias
        location:    Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|home'),
        flash:       {
          alert: I18n.t('kit.auth.notifications.oauth.errors.users_conflict', **i18n_params),
        },
      )
    end
  end

  def self.redirect_if_mismatch_identity_users!(router_conn:, user_oauth_identity:, i18n_params: nil)
    return [:ok] if !user_oauth_identity

    session_user = router_conn.metadata[:session_user]
    return [:ok] if !session_user || session_user.id == user_oauth_identity.user_id

    i18n_params = {
      session_user_email:             session_user.email,
      provider:                       user_oauth_identity.provider,
      user_oauth_identity_user_email: user_oauth_identity.user.email,
    }.merge(i18n_params || {})

    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      # TODO: cleanup redirect strategiy && add alias
      location:    Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|home'),
      flash:       {
        alert: I18n.t('kit.auth.notifications.oauth.errors.users_identity_conflict', **i18n_params),
      },
    )
  end

  def self.associate(router_conn:, omniauth_data:, user:, user_oauth_identity: nil)
    Kit::Organizer.call(
      ok:  [
        [:branch, ->(user_oauth_identity:) { [user_oauth_identity ? nil : :create] }, {
          create: [Kit::Auth::Actions::Oauth::AssociateIdentity],
        },],
        Kit::Auth::Services::UserOauthSecret.method(:create),
      ],
      ctx: {
        router_conn:         router_conn,
        user:                user,
        omniauth_data:       omniauth_data,
        user_oauth_identity: user_oauth_identity,
      },
    )
  end

  def self.create_sign_in(router_conn:, user_oauth_identity:)
    Kit::Organizer.call(
      list: [
        [:local_ctx, Kit::Auth::Actions::Intents::Consume, { intent_step: :user_sign_in }],
        Kit::Auth::Actions::Users::SignInWeb,
      ],
      ctx:  {
        router_conn:    router_conn,
        user:           user_oauth_identity.user,
        sign_in_method: :oauth,
      },
    )
  end

  def self.create_sign_up(router_conn:, email:)
    Kit::Organizer.call(
      list: [
        [:local_ctx, Kit::Auth::Actions::Intents::Consume, { intent_step: :user_sign_up }],
        Kit::Auth::Actions::Users::CreateWithoutPassword,
      ],
      ctx:  {
        router_conn:    router_conn,
        email:          email,
        sign_up_method: :oauth,
      },
    )
  end

  def self.redirect_to_settings(router_conn:, user_oauth_identity:, redirect_url: nil, i18n_params: nil)
    i18n_params = {
      provider: user_oauth_identity.provider,
    }.merge(i18n_params || {})

    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      # TODO: cleanup redirect strategiy && add alias
      location:    redirect_url || Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|home'),
      flash:       {
        success: I18n.t('kit.auth.notifications.oauth.linking.success', **i18n_params),
      },
    )
  end

end
