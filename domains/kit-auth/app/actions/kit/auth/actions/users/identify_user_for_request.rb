module Kit::Auth::Actions::Users::IdentifyUserForRequest

  # TODO: add contract on router_request / cookies (based on needed access)
  #Contract Hash => [Symbol, KeywordArgs[user: Any]]
  def self.call(router_request:, oauth_application:, allow: [:param, :cookie, :header])
    _status, ctx = Kit::Organizer.call(
      list: [
        self.method(:extract_access_token),
        self.method(:find_user),
      ],
      ctx:  {
        router_request:    router_request,
        oauth_application: oauth_application,
        allow:             allow,
      },
    )

    if ctx[:errors]
      [:error, user: nil, errors: ctx[:errors]]
    else
      [:ok, ctx.slice(:user, :oauth_access_token)]
    end
  end

  def self.extract_access_token(router_request:, allow:)
    access_tokens = {
      param:  router_request.params[:access_token],
      cookie: router_request.http&.cookies&.dig(:access_token, :value),
      header: nil,
    }

    # REF: https://www.iana.org/assignments/http-authschemes/http-authschemes.xhtml
    if !(auth_header = router_request.http.headers['Authorization']).blank?
      token = auth_header.split('Bearer ')[1]
      if !token.blank?
        access_tokens[:header] = token
      end
    end

    access_tokens = access_tokens
      .reject { |k, v| !allow.include?(k) || v.blank? }
      .to_h

    values = access_tokens.values.compact.uniq
    if values.size == 0
      return [:error, { attribute: :access_token, desc: 'is missing' }]
    elsif values.size > 1
      return [:error, { attribute: :access_token, desc: 'Conflicting access tokens provided.' }]
    end

    [:ok, access_token: values.first]
  end

  def self.find_user(access_token:, oauth_application:)
    secret_strategy = ::Doorkeeper.configuration.token_secret_strategy
    hashed_secret   = secret_strategy.transform_secret(access_token.to_s)

    oauth_access_token = Kit::Auth::Models::Read::OauthAccessToken.find_by({
      token:          hashed_secret,
      application_id: oauth_application.id,
    })
    user               = oauth_access_token&.user

    if user
      [:ok, user: user, oauth_access_token: oauth_access_token]
    else
      [:error, { attribute: :access_token, desc: 'is invalid' }]
    end
  end

end
