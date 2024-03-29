module Kit::Auth::Actions::AccessTokens::Create

  #Contract Hash => [Symbol, KeywordArgs[access_token: Any, errors: Any]]
  def self.call(user:, application:, access_token_expires_in:, scopes:, extra: nil)
    extra ||= {}

    status, ctx = Kit::Organizer.call(
      list: [
        Kit::Auth::Services::AccessToken.method(:check_scopes),
        Kit::Auth::Services::AccessToken.method(:generate_plaintext_secret),
        Kit::Auth::Services::AccessToken.method(:generate_hashed_secret),
        self.method(:create_access_token),
      ],
      ctx:  {
        user:                    user,
        application:             application,
        access_token_expires_in: access_token_expires_in,
        scopes:                  scopes,
        access_token_extra_data: extra,
      },
    )

    [status, ctx.slice_as(:errors, :access_token, { plaintext_secret: :access_token_plaintext_secret })]
  end

  def self.create_access_token(user:, application:, scopes:, hashed_secret:, secret_strategy:, access_token_expires_in: nil, access_token_extra_data: nil)
    if !access_token_expires_in || access_token_expires_in < 0
      access_token_expires_in = 30.days
    end

    access_token_extra_data ||= {}

    access_token = Kit::Auth::Models::Write::UserSecret.create(
      application_id:  application.id,
      user_id:         user.id,
      category:        :access_token,
      scopes:          scopes,
      secret:          hashed_secret,
      secret_strategy: secret_strategy,
      expires_in:      access_token_expires_in,
      data:            access_token_extra_data,
    )

    [:ok, access_token: access_token]
  end

end
