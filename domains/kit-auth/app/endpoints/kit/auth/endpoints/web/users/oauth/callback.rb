# # OAuth callback endpoint
#
# Define the {.endpoint endpoint} method where external OAuth providers redirect after authorization has been completed.
#
# At this point, we have no knowledge on the user initial intent. This could be fixed by using a session mechanism, but it's simpler to figure out what the most logical action is.
#
# ## Routes aliases
#
# The following routes aliases are used in this flow:
#
# | Alias | Description | Default target |
# | :-: | :-: | :-: |
# | <code>web&#124;users&#124;oauth&#124;error&#124;oauth_data</code> | When the Oauth provider or data is missing or incorrect | <code>web&#124;home</code> |
#
# ⚠️ Extra aliases are used in this flow, but they are listed in on:
#  - {Kit::Auth::Endpoints::Web::Users::Oauth::Callback::SignedIn}
#  -  {Kit::Auth::Endpoints::Web::Users::Oauth::Callback::SignedOut}
#
# ## References
#
# - https://github.com/omniauth/omniauth
# - https://github.com/omniauth/omniauth-oauth2
# - `Kit::Auth::Controllers::Web::Concerns::DefaultRoute.import_omniauth_env`
module Kit::Auth::Endpoints::Web::Users::Oauth::Callback

  # There are two high level scenarios when this endpoint is reached:
  #   - user is signed-in: `Kit::Auth::Endpoints::Web::Users::Oauth::Callback::SignedIn.signed_in`
  #   - user is signed-out: `Kit::Auth::Endpoints::Web::Users::Oauth::Callback::SignedOut.signed_out`
  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      ok:    [
        [:alias, :web_resolve_current_user],
        self.method(:ensure_omniauth_data),
        self.method(:load_user_oauth_identity),
        [:branch, ->(session_user:) { [session_user ? :signed_in : :signed_out] }, {
          signed_in:  [Kit::Auth::Endpoints::Web::Users::Oauth::Callback::SignedIn.method(:signed_in)],
          signed_out: [Kit::Auth::Endpoints::Web::Users::Oauth::Callback::SignedOut.method(:signed_out)],
        },],
      ],
      error: [
        -> { [:ok, redirect_url: Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|oauth|error|oauth_data')] },
        Kit::Domain::Endpoints::Http.method(:redirect_with_errors),
      ],
      ctx:   { router_conn: router_conn },
    )
  end

  def self.register_endpoint
    Kit::Router::Services::Router.register(
      uid:     'kit_auth|web|users|oauth|callback',
      aliases: ['web|users|oauth|callback'],
      target:  self.method(:endpoint),
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

end
