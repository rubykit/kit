module Kit::Auth::Services::OauthAccessToken

  #Contract KeywordArgs[oauth_access_token: Any] => Bool
  def self.is_active?(oauth_access_token:)
    expired = DateTime.now > (oauth_access_token.created_at + oauth_access_token.expires_in)
    revoked = !!oauth_access_token.revoked_at

    !expired && !revoked
  end

  def self.revoke(oauth_access_token:)
    oauth_access_token
      .to_write_record
      .update(revoked_at: DateTime.now)

    [:ok]
  end

end