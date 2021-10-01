# Various function to handle `access_token`s.
module Kit::Auth::Services::AccessToken

  # Generate a plaintext secret.
  def self.generate_plaintext_secret(secret_length: nil)
    secret_length  ||= 32
    plaintext_secret = ::SecureRandom.urlsafe_base64(secret_length)

    [:ok, plaintext_secret: plaintext_secret]
  end

  # Generate the hashed version of a secret using a given strategy (default is sha256)
  def self.generate_hashed_secret(plaintext_secret:, secret_strategy: nil)
    secret_strategy ||= :sha256

    case secret_strategy
    when :sha256
      hasher = ::Doorkeeper::SecretStoring::Sha256Hash
    when :bcrypt
      hasher = ::Doorkeeper::SecretStoring::BCrypt
    else
      return [:error, { detail: "Unknown hashing secret strategy `#{ secret_strategy }`" }]
    end

    hashed_secret = hasher.transform_secret(plaintext_secret)

    [:ok, hashed_secret: hashed_secret, secret_strategy: secret_strategy]
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

  # Attempts to revoke an `access_token`.
  def self.revoke(access_token:)
    return [:ok] if access_token.revoked?

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

end
