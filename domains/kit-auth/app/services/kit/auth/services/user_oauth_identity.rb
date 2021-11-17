# Code to manipulate `UserOauthIdentities`
module Kit::Auth::Services::UserOauthIdentity

  def self.create(omniauth_data:, user:)
    user_oauth_identity = Kit::Auth::Models::Write::UserOauthIdentity.create(
      user_id:      user.id,
      provider:     omniauth_data[:oauth_provider],
      provider_uid: omniauth_data[:uid],
      data:         omniauth_data[:info],
    )

    [:ok, user_oauth_identity: user_oauth_identity.to_read_record]
  end

  def self.destroy(user_oauth_identity:)
    user_oauth_identity = user_oauth_identity.to_write_record

    user_oauth_identity.user_oauth_secrets.destroy_all
    user_oauth_identity.destroy

    if user_oauth_identity.deleted?
      [:ok]
    else
      [:error, code: :destroy_failed]
    end
  end

end
