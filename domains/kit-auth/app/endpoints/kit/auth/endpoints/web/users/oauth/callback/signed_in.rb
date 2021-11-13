# ## Oauth Callback
#
# Used on OAuth redirect when the user is already signed-in.
#
# ---
#
# ### Default high level implementation:
#
# <p align="center">
#   <img src="https://kroki.io/mermaid/svg/eNqNkjFvwjAQhXd-xVUsQQpSExGUgtTKKQwsZWg7dKos-0KsujG1nZZK_PieCTRELIz3_N53z5Y3lm8reFkMBgAsWu6U86rewKtDu-aNr1YSa6_878OIDGRJolYRXENDJjD1pRl4LcFXCBa_GnT-GA5xFi0M1MZXtKVTi2hprbE3xyVptHKwteZbSbTv-MmVBq4tcklo77mokPiG1hCIOoQC3Y6U9WhBKaJHSnu8rDo6XBzG4_v92_J5T13-56c1jWkYk_Nz1ikHR1IEIT2zpKxTWkgRtgjNnVtgCVx4Rc9WKq1nwzzPY-et-cDxj5K-mt1ud7Ew2tjZsCzL-SkILGZJTNQ2Pe8RXSMEkqdF8qnMs8mV1LQ4pftIDE94BMppJjJxJTApqCVr831kjY239G9aKGZicndty4Sd0vM_4SXTOA==">
# </p>
#
# ---
#
# ## Routes aliases
#
# The following routes aliases are used in this file:
#
# | Alias | Description | Default target |
# | :-: | :-: | :-: |
# | <code>web&#124;users&#124;oauth&#124;new_identity</code> | After a new OAuth identity was added to an already signed-in account | <code>web&#124;users&#124;settings&#124;oauth</code> |
# | <code>web&#124;users&#124;oauth&#124;no_op</code> | Already signed-in & associated account: nothing to do. | <code>web&#124;users&#124;settings&#124;oauth</code> |
# | <code>web&#124;users&#124;oauth&#124;error&#124;mismatch_identity_users</code> | | <code>web&#124;users&#124;settings&#124;oauth</code> |
# | <code>web&#124;users&#124;oauth&#124;error&#124;email_ownership</code> | | <code>web&#124;users&#124;settings&#124;oauth</code> |
#
module Kit::Auth::Endpoints::Web::Users::Oauth::Callback::SignedIn

  # Called by `Kit::Auth::Endpoints::Web::Users::Oauth::Authentify.endpoint` when the User is already signed-in.
  #
  # ### Flow
  #
  # - Is there an existing `UserOauthIdentity` with the correct `provider_uid` in the database ?
  #    - *YES*: Identical user on `UserOauthIdentity` and the request?
  #       - *YES*: {.signed_in_with_identity}
  #       - *NO*: {.signed_in_with_identity_user_mismatch}
  #    - *NO*: Is `provider_email` already attached to another `User`?
  #       - YES: {.signed_in_without_identity_user_mismatch}
  #       - NO: {.signed_in_without_identity}
  def self.signed_in(router_conn:, omniauth_data:, user_oauth_identity:, session_user:)
    Kit::Organizer.call(
      ok:  [
        [:branch, ->(user_oauth_identity:) { [user_oauth_identity ? :has_identity : :no_identity] }, {
          has_identity: [:nest, {
            ok:    [
              self.method(:ensure_user_match_oauth_identity),
              self.method(:signed_in_with_identity),
            ],
            error: [
              self.method(:signed_in_with_identity_user_mismatch),
            ],
          },],
          no_identity:  [:nest, {
            ok:    [
              self.method(:ensure_no_user_with_email),
              self.method(:signed_in_without_identity),
            ],
            error: [
              self.method(:signed_in_without_identity_user_mismatch),
            ],
          },],
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

  def self.signed_in_with_identity(router_conn:, redirect_url: nil)
    redirect_url ||= Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|oauth|no_op')

    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    redirect_url,
    )
  end

  def self.signed_in_with_identity_user_mismatch(router_conn:, session_user:, omniauth_data:, user_oauth_identity:, redirect_url: nil)
    redirect_url ||= Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|oauth|error|mismatch_identity_users')

    i18n_params = {
      session_user_email:             session_user.email,
      provider:                       omniauth_data[:oauth_provider],
      user_oauth_identity_user_email: user_oauth_identity.user.email,
    }.merge(i18n_params || {})

    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    redirect_url,
      flash:       {
        alert: I18n.t('kit.auth.notifications.oauth.errors.users_identity_conflict', **i18n_params),
      },
    )
  end

  # The visitor is signed-in & there is no existing UserOauthIdentity
  #
  # Default implementation:
  #   - save the provider data (create new `UserOauthIdentity`)
  #   - save the new provider tokens (create new `UserOauthSecrets`)
  #   - redirect to `web|users|oauth|new_identity`
  def self.signed_in_without_identity(router_conn:, omniauth_data:, session_user:)
    Kit::Organizer.call(
      ok:  [
        Kit::Auth::Actions::Oauth::AssociateIdentity,
        Kit::Auth::Services::UserOauthSecret.method(:create),
        self.method(:redirect_connect_oauth_account),
      ],
      ctx: {
        router_conn:   router_conn,
        omniauth_data: omniauth_data,
        user:          session_user,
      },
    )
  end

  def self.redirect_connect_oauth_account(router_conn:, user_oauth_identity:, redirect_url: nil)
    redirect_url ||= Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|oauth|new_identity')

    i18n_params = {
      provider: user_oauth_identity.provider,
    }.merge(i18n_params || {})

    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    redirect_url,
      flash:       {
        success: I18n.t('kit.auth.notifications.oauth.linking.success', **i18n_params),
      },
    )
  end

  def self.signed_in_without_identity_user_mismatch(router_conn:, omniauth_data:, redirect_url: nil)
    redirect_url ||= Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|oauth|error|email_ownership')

    i18n_params = {
      provider:       omniauth_data[:oauth_provider],
      provider_email: omniauth_data[:info][:email],
    }.merge(i18n_params || {})

    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    redirect_url,
      flash:       {
        alert: I18n.t('kit.auth.notifications.oauth.errors.users_conflict', **i18n_params),
      },
    )
  end

  def self.ensure_no_user_with_email(router_conn:, session_user:, omniauth_data:)
    email       = omniauth_data[:info][:email]
    status, ctx = Kit::Auth::Services::UserEmail.find_user_by_email(email: email)

    if status == :error || ctx[:user].id == session_user.id
      [:ok]
    else
      [:error, code: :user_oauth_email_ownership]
    end
  end

  def self.ensure_user_match_oauth_identity(router_conn:, session_user:, user_oauth_identity:)
    if session_user.id == user_oauth_identity.user_id
      [:ok]
    else
      [:error, code: :user_oauth_identity_mismatch]
    end
  end

end
