# Various function to handle `access_token`s.
module Kit::Auth::Services::AccessTokenRequest

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
  def self.extract_plaintext_secrets_by_field(router_conn:, token_types: nil)
    token_types ||= [:param, :cookie, :header]

    secrets = {
      header: nil,
      param:  router_conn.dig(:request, :params, :access_token),
      cookie: router_conn.dig(:request, :http, :cookies, :access_token, :value),
    }

    if !(auth_header = router_conn.dig(:request, :http, :headers, 'Authorization')).blank?
      token = auth_header.split('Bearer ')[1]
      if !token.blank?
        secrets[:header] = token
      end
    end

    secrets = secrets
      .reject { |k, _v| !token_types.include?(k) }
      .map    { |k, v| [k, v.blank? ? nil : v] }
      .to_h

    [:ok, plaintext_secrets_by_field: secrets]
  end

  # Categorize tokens in 2 groups:
  # - `session` tokens: if present, expected to be received in every request (usually through `cookies`)
  # - `request` tokens: if present, might be specific to only this request (`query_params`, `body_params`, `headers`)
  #
  # It can make sense to receive both a `session` & `request` tokens:
  #  - ex: user is logged in with session token and confirm an email with params token
  #
  # Receiving multiple "request" tokens is often an error, except if your app has specific knowledge to handle it.
  #
  # ⚠️ Only the first non nil secret is selected for each type.
  #
  def self.categorize_plaintext_secrets(plaintext_secrets_by_field:, session_types: nil, request_types: nil)
    session_types ||= [:cookie]
    request_types ||= [:param, :header]

    secrets = {}

    { session: session_types, request: request_types }.each do |key, types|
      secret = plaintext_secrets_by_field
        .select { |k, _v| k.in?(types) }
        .reject { |_k, v| v.blank? }
        .first

      secrets[key] = secret ? secret[1] : nil
    end

    [:ok, plaintext_secrets: secrets]
  end

  # Attempt to find `access_token` models in the database for each field type.
  def self.find_access_token_models(plaintext_secrets:, application:, secret_strategy: nil)
    access_tokens = plaintext_secrets
      .map do |type, plaintext_secret|
        if plaintext_secret
          _, ctx = find_access_token_model(
            plaintext_secret: plaintext_secret,
            application:      application,
            secret_strategy:  secret_strategy,
          )

          [type, ctx[:access_token]]
        else
          [type, nil]
        end
      end
      .to_h

    [:ok, access_tokens: access_tokens]
  end

  # Attempt to find the `access_token` in the database.
  #
  # In order to do this, the hashing method that was used to generate the hashed token that is in the DB needs to be known.
  def self.find_access_token_model(plaintext_secret:, application:, secret_strategy: nil)
    status, ctx = Kit::Auth::Services::AccessToken.generate_hashed_secret(
      plaintext_secret: plaintext_secret,
      secret_strategy:  secret_strategy,
    )
    return [status, ctx] if status == :error

    secret_strategy = ctx[:secret_strategy]
    hashed_secret   = ctx[:hashed_secret]

    access_token = Kit::Auth::Models::Read::UserSecret.find_by({
      application_id:  application.id,
      secret:          hashed_secret,
      secret_strategy: secret_strategy,
      category:        [:access_token, :oauth_access_token],
    })

    [:ok, access_token: access_token]
  end

end
