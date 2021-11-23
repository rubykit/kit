# Code to manipulate `UserOauthSecrets`
module Kit::Auth::Services::UserOauthSecret

  def self.create(omniauth_data:, user_oauth_identity:)
    expires_at = omniauth_data[:credentials][:expires_at]
    expires_at = expires_at ? DateTime.strptime(expires_at.to_s, '%s') : nil

    user_oauth_secret = Kit::Auth::Models::Write::UserOauthSecret.create(
      user_oauth_identity_id: user_oauth_identity.id,
      provider_app_id:        omniauth_data[:app_id],

      token:                  omniauth_data[:credentials][:token],
      refresh_token:          omniauth_data[:credentials][:refresh_token],

      expires_at:             expires_at,
    )

    [:ok, user_oauth_secret: user_oauth_secret.to_read_record]
  end

end
