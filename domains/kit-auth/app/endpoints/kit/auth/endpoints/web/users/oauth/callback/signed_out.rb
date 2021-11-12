# ## Flow
#
# - Is there an existing `UserOauthIdentity` with the correct `provider_uid` in the database ?
#    - *YES*: {.signed_out_with_identity}
#    - *NO*:  Is there an existing `User` with the `provider_email` in the database ?
#       - *YES*: {.signed_out_without_identity_existing_user}
#       - *NO*: {.signed_out_without_identity_no_user}
#
# ### Default high level implementation:
#
# <p align="center">
#   <img src="https://kroki.io/mermaid/svg/eNqNjkFLwzAYhu_9FR8MZEIKNqiUFpSE7eDFHaYHTxLSpA1mSUlSnbAfb0JWt13EQw5vvud9vq93bBzgZVUUAHS53isflOnh1Qu3YVMYnjphggrfj9cRiEi13KregDLHjC87sGOBDymNzn6qTrh3sWNKH-upQGYDXAF3ggWRt5GzbSeaZnoa_6TT8VCWD4e39fYQj_zNz5sYcYr4bI7J6ScTNCm4Zt6vhATGg7IGpNK6WdR1jXxw9kOUX6oLQ3Mz7hG32rpmIaVs5yIQRCpEMKIoqrOivdD6iXMRwexl9119d_s_Na2ik8RH4wIyi9riB92lhqI=">
# </p>
#
# ---
#
# ## Routes aliases
#
# The following routes aliases are used in this flow:
#
# | Alias | Description | Default target |
# | :-: | :-: | :-: |
# | <code>web&#124;users&#124;oauth&#124;sign_in&#124;after</code> | After an OAuth sign-in when no new `UserOauthIdentity` was created | <code>web&#124;users&#124;sign_in&#124;after</code> |
# | <code>web&#124;users&#124;oauth&#124;sign_in&#124;after_with_new_identity</code> | After an OAuth sign-in when a new `UserOauthIdentity` was created | <code>web&#124;users&#124;oauth&#124;sign_in&#124;after</code> |
# | <code>web&#124;users&#124;oauth&#124;sign_up&#124;after</code> | After an OAuth sign-up | <code>web&#124;users&#124;sign_up&#124;after</code> |
#
module Kit::Auth::Endpoints::Web::Users::Oauth::Callback::SignedOut

  # Flow when the user is signed-out.
  def self.signed_out(router_conn:, omniauth_data:, user_oauth_identity:)
    Kit::Organizer.call(
      ok:  [
        [:branch, ->(user_oauth_identity:) { [user_oauth_identity ? :has_identity : :no_identity] }, {
          has_identity: [
            self.method(:signed_out_with_identity),
          ],
          no_identity:  [
            ->(router_conn:) { [:ok, user: Kit::Auth::Services::UserEmail.find_user_by_email(router_conn.metadata[:oauth][:info][:email])[1][:user]] },
            [:branch, ->(user:) { [user ? :user_exists : :no_user] }, {
              user_exists: [self.method(:signed_out_without_identity_existing_user)],
              no_user:     [self.method(:signed_out_without_identity_no_user)],
            },],
          ],
        },],
      ],
      ctx: {
        router_conn:         router_conn,
        omniauth_data:       omniauth_data,
        user_oauth_identity: user_oauth_identity,
      },
    )
  end

  # The visitor is signed-out & `UserOauthIdentity` exists in the database
  #
  # Default implementation:
  #   - save the new provider tokens (create new UserOauthSecrets)
  #   - sign the user in
  #   - redirect to `web|users|oauth|sign_in|after`
  def self.signed_out_with_identity(router_conn:, omniauth_data:, user_oauth_identity:)
    Kit::Organizer.call(
      ok:  [
        self.method(:create_user_oauth_secret),
        self.method(:create_sign_in),
        -> { [:ok, redirect_url: 'web|users|oauth|sign_in|after'] },
        Kit::Auth::Endpoints::Web::Users::SignIn::WithPassword::Create.method(:redirect),
      ],
      ctx: {
        router_conn:         router_conn,
        omniauth_data:       omniauth_data,
        user_oauth_identity: user_oauth_identity,
      },
    )
  end

  # The visitor is signed-out & `User` exists in the database & there is no existing UserOauthIdentity
  #
  # Default implementation:
  #   - save the provider data (create new `UserOauthIdentity`)
  #   - save the new provider tokens (create new `UserOauthSecrets`)
  #   - sign the user in
  #   - redirect to `web|users|oauth|sign_in|after_with_new_identity`
  #
  # TODO: add flash notification for connection Oauth provider (similar to {SignedOut.redirect_connect_oauth_account})
  def self.signed_out_without_identity_existing_user(router_conn:, omniauth_data:, user:)
    Kit::Organizer.call(
      ok:  [
        Kit::Auth::Actions::Oauth::AssociateIdentity,
        Kit::Auth::Services::UserOauthSecret.method(:create),
        self.method(:create_sign_in),
        -> { [:ok, redirect_url: 'web|users|oauth|sign_in|after_with_new_identity'] },
        Kit::Auth::Endpoints::Web::Users::SignIn::WithPassword::Create.method(:redirect),
      ],
      ctx: {
        router_conn:   router_conn,
        omniauth_data: omniauth_data,
        user:          user,
      },
    )
  end

  # The visitor is signed-out & `User` does not exists in the database
  #
  # Default implementation:
  #   - save the provider data (create new `UserOauthIdentity`)
  #   - save the new provider tokens (create new `UserOauthSecrets`)
  #   - sign the user up (create new `User`)
  #   - sign the user in
  #   - redirect to `web|users|oauth|sign_up|after`
  def self.signed_out_without_identity_no_user(router_conn:, omniauth_data:)
    Kit::Organizer.call(
      ok:  [
        Kit::Auth::Actions::Oauth::AssociateIdentity,
        Kit::Auth::Services::UserOauthSecret.method(:create),
        self.method(:create_sign_up),
        self.method(:create_sign_in),
        -> { [:ok, redirect_url: 'web|users|oauth|sign_up|after'] },
        Kit::Auth::Endpoints::Web::Users::SignUp::WithPassword::Create.method(:redirect),
      ],
      ctx: {
        router_conn:   router_conn,
        omniauth_data: omniauth_data,
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

end
