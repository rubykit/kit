require 'bcrypt'
require 'dry-validation'

# TODO: audit if going through Doorkeeper is worth doing

class Kit::Auth::Actions::Users::GetAccessTokenForUser
  include Contracts

  #Contract Hash => [Symbol, KeywordArgs[oauth_access_token: Any, errors: Any]]
  def self.call(user:, **)
    request_object = Doorkeeper::OAuth::PasswordAccessTokenRequest.new(
      Doorkeeper.configuration,
      Doorkeeper::Application.find_by!(name: 'self'),
      user,
      {
        scope: nil,
      }
    )

    request_object.validate
    if request_object.valid?
      access_token = request_object.find_or_create_access_token(
        request_object.client,
        request_object.resource_owner.id,
        request_object.scopes,
        request_object.server
      )

      oauth_access_token = Kit::Auth::Models::Read::OauthAccessToken.find(access_token.id)

      [:ok, oauth_access_token: oauth_access_token]
    else
      [:error, errors: [{ msg: request_object.error }]]
    end
  end

end