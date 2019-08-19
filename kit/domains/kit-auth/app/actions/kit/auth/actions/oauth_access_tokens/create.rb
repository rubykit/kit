# TODO: audit if going through Doorkeeper is worth doing
module Kit::Auth::Actions::OauthAccessTokens::Create

  #Contract Hash => [Symbol, KeywordArgs[oauth_access_token: Any, errors: Any]]
  def self.call(user:, oauth_application:, oauth_access_token_expires_in:, scopes:)
    Kit::Organizer.call({
      ctx: {
        user:                          user,
        oauth_application:             oauth_application,
        oauth_access_token_expires_in: oauth_access_token_expires_in,
        scopes:                        scopes,
      },
      list: [
        self.method(:create_doorkeeper_request_object),
        self.method(:create_doorkeeper_access_token),
        self.method(:load_oauth_access_token),
      ],
    })
  end

  def self.create_doorkeeper_request_object(user:, oauth_application:, scopes: nil)
    request_object = ::Doorkeeper::OAuth::PasswordAccessTokenRequest.new(
      ::Doorkeeper.configuration,
      ::Doorkeeper::Application.find!(oauth_application.id),
      user,
      {
        scope: scopes,
      }
    )

    request_object.validate
    if request_object.valid?
      [:ok, doorkeeper_request_object: request_object]
    else
      [:error, errors: [{ detail: request_object.error }]]
    end
  end

  # LINK: https://github.com/doorkeeper-gem/doorkeeper/blob/master/lib/doorkeeper/oauth/base_request.rb#L35
  def self.create_doorkeeper_access_token(doorkeeper_request_object:, oauth_access_token_expires_in:)
    if oauth_access_token_expires_in < 0
      oauth_access_token_expires_in = 30.days
    end

    client                = doorkeeper_request_object.client
    scopes                = doorkeeper_request_object.scopes
    resource_owner_id     = doorkeeper_request_object.resource_owner,
    refresh_token_enabled = false

    access_token = ::AccessToken.find_or_create_for(
      client,
      resource_owner_id,
      scopes,
      oauth_access_token_expires_in,
      refresh_token_enabled
    )

    [:ok, doorkeeper_access_token: access_token]
  end

  def self.load_oauth_access_token(doorkeeper_access_token:)
    just_created       = doorkeeper_access_token.id_previously_changed?
    plaintext_secret   = doorkeeper_access_token.plaintext_token

    oauth_access_token = Kit::Auth::Models::Read::OauthAccessToken.find(doorkeeper_access_token.id)

    [:ok, {
      oauth_access_token:                  oauth_access_token,
      oauth_access_token_created:          just_created,
      oauth_access_token_plaintext_secret: plaintext_secret,
    }]
  end

end