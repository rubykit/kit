module Kit::Auth::Actions::Users::IdentifyUserForRequest
  include Contracts

  # Todo: add contract on request / cookies (based on needed access)
  #Contract Hash => [Symbol, KeywordArgs[user: Any]]
  def self.call(request:, cookies:, oauth_application:)
    status, ctx = Kit::Organizer.call({
      ctx: {
        request:           request,
        cookies:           cookies,
        oauth_application: oauth_application,
      },
      list: [
        self.method(:extract_access_token),
        self.method(:find_user),
      ],
    })

    if ctx[:errors]
      [:error, user: nil, errors: ctx[:errors]]
    else
      [:ok, ctx.slice(:user, :oauth_access_token)]
    end
  end

  def self.extract_access_token(request:, cookies:)
    access_token = request.params[:access_token]

    if access_token.blank?
      if request.authorization.present?
        access_token, _options = ActionController::HttpAuthentication::Token.token_and_options(request)
      end
    end

    if access_token.blank?
      access_token = cookies.encrypted[:access_token]
    end

    if access_token.blank?
      access_token = nil
    end

    [:ok, access_token: access_token]
  end

  def self.find_user(access_token:, oauth_application:)
    return [:error] if access_token == nil || oauth_application == nil

    oauth_access_token = Kit::Auth::Models::Read::OauthAccessToken.find_by({
      token:          access_token,
      application_id: oauth_application.id,
    })
    user               = oauth_access_token&.user

    if user
      [:ok, user: user, oauth_access_token: oauth_access_token]
    else
      [:error]
    end
  end

end