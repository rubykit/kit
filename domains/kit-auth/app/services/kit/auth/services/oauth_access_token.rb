# Various function to handle `access_token`s.
module Kit::Auth::Services::OauthAccessToken

  # Attempts to revoke an `oauth_access_token`.
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

  # Attempt to find an `access_token` in a `RouterConn`.
  #
  # The following fields are checked in this order:
  #   - `Authorization` header
  #   - `access_token` query_params
  #   - `access_token` cookie
  #
  # The first value found is returned.
  #
  # ### References
  # - https://www.iana.org/assignments/http-authschemes/http-authschemes.xhtml
  def self.extract_access_token(router_conn:, token_types: nil)
    token_types ||= [:param, :cookie, :header]

    access_tokens = {
      header: nil,
      param:  router_conn.dig(:request, :params, :access_token),
      cookie: router_conn.dig(:request, :http, :cookies, :access_token, :value),
    }

    if !(auth_header = router_conn.dig(:request, :http, :headers, 'Authorization')).blank?
      token = auth_header.split('Bearer ')[1]
      if !token.blank?
        access_tokens[:header] = token
      end
    end

    access_tokens = access_tokens
      .reject { |k, v| !token_types.include?(k) || v.blank? }
      .to_h

    if access_tokens.size == 0
      [:error, { attribute: :access_token, type: :missing, desc: 'is missing' }]
    else
      access_token = access_tokens.first
      [:ok, access_token: access_token[1], access_token_type: access_token[0]]
    end
  end

  # Attempt to find the `access_token` in the database.
  #
  # In order to do this, the hashing method that was used to generate the hashed token that is in the DB needs to be known.
  def self.find_oauth_access_token(access_token:, oauth_application:)
    secret_strategy = ::Doorkeeper.configuration.token_secret_strategy
    hashed_secret   = secret_strategy.transform_secret(access_token.to_s)

    oauth_access_token = Kit::Auth::Models::Read::OauthAccessToken.find_by({
      token:          hashed_secret,
      application_id: oauth_application.id,
    })

    [:ok, oauth_access_token: oauth_access_token]
  end

end
