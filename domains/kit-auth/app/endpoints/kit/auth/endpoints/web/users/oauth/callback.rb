# # OAuth callback endpoint
#
# Define the `.endpoint` where external OAuth providers redirect after authorization has been completed.
#
# At this point, we have no knowledge on the user initial intent. This could be fixed by using a session mechanism, but it's simpler to figure out what the most logical action is.
#
# ---
#
# ## When the user is signed-out
#
# ![Signed-out flow chart](https://kroki.io/mermaid/svg/eNqNzkFrgzAYBuB7f8UHhWEhwnRanMJGssrwogPbw04lxFjDnEqMawf98YtTu3nzkMOXvO-T7yRpU8B-t1oBECO8iFaJ6gSHlsuEdqqIMl4pob6fNzqgI5ZhgQlp9Bofo3i8s-c9OAtVgCo4NLL-EhmXR_5JRTkSfQEbtlZwmiYvEd6HcDcX-wgxHqaPDm86cAtvflcF03y6vofpVa90m-NEj3Y_2v_ebfx3MyRIT7CStu2O50CZEnUFuShLf-15HmqVrD-4eRaZKvz75oJYXdbSX-d5HkxFwAhbCNuIIE0PRDBj244xroODS7eZ5zrLaGJpE-tD9Ad4guY6l7KWo51tXeayhWtbPUqG_pyseKckLUeUu8x5dJaieGoHqx92zK_E)
#
# - Is there an existing `UserOauthIdentity` with the correct `provider_uid` in the database ?
#    - YES: `.action_1`
#       - sign the user in
#       - save the new provider tokens
#       - redirect to `web|users|oauth|sign_in|after`
#    - NO:  Is there an existing `User` with the `provider_email` in the database ?
#       - YES: `.action_2`
#          - associate the provider identity to the user
#          - sign the user in, save the new provider tokens
#          - redirect to `web|users|oauth|sign_in|after_new_identity`
#       - NO: `.action_3`
#          - sign up the user
#          - associate the provider identity
#          - sign the user in
#          - save the new provider tokens
#          - redirect to `web|users|oauth|sign_up|after`
#
# ---
#
# ## When the user is already signed-in
#
# ![Signed-in flow chart](https://kroki.io/mermaid/svg/eNqNkjFvgzAQhff-ipOyEAmkgkJKE6mVaRiyhCpJh06VZY5gleLUNm0q5cf3gKQEdcl4z-9992x5p_m-gO3i5gaAOclBGiurHbwY1CmvbbHMsLLS_jyOyUAW3-kUwUuoyQSq-m8GXmVgCwSNnzUaewo3ceZMwINV6qXPvRg7IYnJep2uT2sCZ2lawl6rL5mhfsMPLkvgxighuUXiK1qjyKPbAv2OgDnTIa4RY-eORLbZpE9Ltk3G7YXB8x6Or8nmSCX-5lVKY9CM_uU565XW4ceNEFxYAtYrHSRutoiSWi8wBy6spOfKZVnORlEUucZq9Y7et8xsMbvdH1yhSqVnozzP5-cgMJf5LlG79HxANLUQSJ4OyadZFE6upAbxOT1EotZKn4DZNBShuBLox9SSdfkhssLaavovHRRDMbm_tqXPzun5L32Byp4=)
#
# - Is there an existing `UserOauthIdentity` with the correct `provider_uid` in the database ?
#    - YES: Identical user on `UserOauthIdentity` and the request?
#       - YES: `.action_4`
#          - nothing specific to do here!
#          - redirect to `web|users|oauth|no_op`
#       - NO: `.action_5`
#          - error out (this should only happen when trying to associate a provider account already attached to another `User`)
#          - redirect to `web|users|oauth|error|mismatch_identity_users`
#    - NO: Is `provider_email` associated to another User?
#       - YES: `.action_6`
#          - error out
#          - redirect to `web|users|oauth|error|email_ownership`
#       - NO: `.action_7`
#          - associate the email to the account if it is not already
#          - associate the provider identity
#          - save the new provider tokens
#          - redirect to `web|users|oauth|new_identity`
#
# ---
#
# ## Routes aliases
#
# The following aliases are used in this flow:
#
# | Alias | Description | Default target |
# | :-: | :-: | :-: |
# | <code>web&#124;users&#124;oauth&#124;sign_in&#124;after</code> | After an OAuth sign-in when no new `UserOauthIdentity` was created | <code>web&#124;users&#124;sign_in&#124;after</code> |
# | <code>web&#124;users&#124;oauth&#124;sign_in&#124;after_new_identity</code> | After an OAuth sign-in where a new `UserOauthIdentity` was created | <code>web&#124;users&#124;oauth&#124;sign_in&#124;after</code> |
# | <code>web&#124;users&#124;oauth&#124;sign_up&#124;after</code> | After OAuth sign-up | <code>web&#124;users&#124;sign_up&#124;after</code> |
# | <code>web&#124;users&#124;oauth&#124;no_op</code> | Already signed-in & associated account: nothing to do. | <code>web&#124;users&#124;settings&#124;oauth</code> |
# | <code>web&#124;users&#124;oauth&#124;error&#124;mismatch_identity_users</code> | | <code>web&#124;users&#124;settings&#124;oauth</code> |
# | <code>web&#124;users&#124;oauth&#124;error&#124;email_ownership</code> | | <code>web&#124;users&#124;settings&#124;oauth</code> |
# | <code>web&#124;users&#124;oauth&#124;new_identity</code> | After a new OAuth identity was added to an already signed-in account | <code>web&#124;users&#124;settings&#124;oauth</code> |
#
# ## References
#
# - https://github.com/omniauth/omniauth
# - https://github.com/omniauth/omniauth-oauth2
# - `Kit::Auth::Controllers::Web::Concerns::DefaultRoute.import_omniauth_env`
module Kit::Auth::Endpoints::Web::Users::Oauth::Callback

  # There are two high level scenarios when this endpoint is reached:
  #   - `User` is signed-in
  #   - `User` is signed-out
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

  # When `User` is already signed-in
  #   - When a `UserOauthIdentity` was found
  #     - Different user on UAI & Session: ERROR_OUT
  #   - No existing UserOauthIdentity:
  #     - Same email on session_user OR no user with provider_email: ASSOCIATE
  #     - Email on another User: simplest strategy: ERROR_OUT
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

  # Ensure the OmniAuth data is present in the request and the oauth provider is supported.
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

  # Attempt to find an existing `UserOauthIdentity` based on the `provider_uid`.
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

  # Associate the OAuth data with the `:user`.
  #
  # - Create a `UserOauthIdentity` when it's missing.
  # - Create a `UserOauthSecret` to save the new access tokens that were returned.
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

  # Handle sign-in intent & signs the User in.
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

  # Handle sign-up intent & signs the User up.
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
