module Kit::Auth::Services::OauthAccessToken

  def self.active?(oauth_access_token:)
    expired = DateTime.now > (oauth_access_token.created_at + oauth_access_token.expires_in)
    revoked = !!oauth_access_token.revoked_at

    !expired && !revoked
  end

  def self.revoke(oauth_access_token:)
    status = oauth_access_token
      .to_write_record
      .update(revoked_at: DateTime.now)

    if status
      oauth_access_token.reload
      [:ok, oauth_access_token: oauth_access_token]
    else
      [:error, "Could not revoke access token ##{ oauth_access_token.id }."]
    end
  end

end
