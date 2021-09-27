# Various function to handle `access_token`s.
module Kit::Auth::Services::AccessToken

  # Attempts to revoke an `access_token`.
  def self.revoke(access_token:)
    status = access_token
      .to_write_record
      .update(revoked_at: DateTime.now)

    if status
      access_token.reload
      [:ok, access_token: access_token]
    else
      [:error, "Could not revoke access token ##{ access_token.id }."]
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
  def self.extract_access_token_paintext_secret(router_conn:, token_types: nil)
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
      [:ok, access_token_plaintext_secret: access_token[1], access_token_type: access_token[0]]
    end
  end

  # Attempt to find the `access_token` in the database.
  #
  # In order to do this, the hashing method that was used to generate the hashed token that is in the DB needs to be known.
  def self.find_access_token_model(access_token_plaintext_secret:, application:, secret_strategy: nil)
    status, ctx = generate_hashed_secret(access_token_plaintext_secret: access_token_plaintext_secret, secret_strategy: secret_strategy)
    return [status, ctx] if status == :error

    secret_strategy            = ctx[:secret_strategy]
    access_token_hashed_secret = ctx[:access_token_hashed_secret]

    access_token = Kit::Auth::Models::Read::UserSecret.find_by({
      application_id:  application.id,
      secret:          access_token_hashed_secret,
      secret_strategy: secret_strategy,
      category:        [:access_token, :access_token],
    })

    [:ok, access_token: access_token]
  end

  # Generate a plaintext secret.
  def self.generate_plaintext_secret(secret_length: nil)
    secret_length  ||= 32
    plaintext_secret = ::SecureRandom.urlsafe_base64(secret_length)

    [:ok, access_token_plaintext_secret: plaintext_secret]
  end

  # Generate the hashed version of a secret using a given strategy (default is sha256)
  def self.generate_hashed_secret(access_token_plaintext_secret:, secret_strategy: nil)
    secret_strategy ||= :sha256

    case secret_strategy
    when :sha256
      hasher = ::Doorkeeper::SecretStoring::Sha256Hash
    when :bcrypt
      hasher = ::Doorkeeper::SecretStoring::BCrypt
    else
      return [:error, { detail: "Unknown hashing secret strategy `#{ secret_strategy }`" }]
    end

    hashed_secret = hasher.transform_secret(access_token_plaintext_secret)

    [:ok, access_token_hashed_secret: hashed_secret, secret_strategy: secret_strategy]
  end

  def self.check_scopes(application:, scopes: nil, grant_type: nil)
    scopes = [scopes] if !scopes.is_a?(Array)
    scopes = scopes.map(&:to_s).join(' ')

    if !scopes.blank? && !::Doorkeeper::OAuth::Helpers::ScopeChecker.valid?(
      scope_str:     scopes,
      server_scopes: ::Doorkeeper.configuration.scopes,
      app_scopes:    application.scopes,
      grant_type:    grant_type,
    )
      return [:error, { code: :invalid_scope, detail: I18n.t('doorkeeper.errors.messages.invalid_scope') }]
    end

    [:ok]
  end

end
