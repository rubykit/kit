module Kit::Auth::Actions::Users::EnsureActiveToken

  def self.call(router_conn:, oauth_access_token:)
    error = nil

    if !oauth_access_token
      error = { detail: 'Missing token', code: :oauth_token_missing }
    elsif oauth_access_token.revoked?
      error = { detail: 'Revoked token', code: :oauth_token_revoked }
    elsif oauth_access_token.expired?
      error = { detail: 'Expired token', code: :oauth_token_expired }
    end

    if error
      # CLeanup cookies in case that's where we got the token from.
      router_conn.response[:http][:cookies][:access_token] = { value: nil, encrypted: true }

      [:error, error]
    else
      [:ok]
    end
  end

end
