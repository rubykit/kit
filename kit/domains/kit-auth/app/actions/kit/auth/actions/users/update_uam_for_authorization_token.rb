require 'bcrypt'
require 'dry-validation'

# TODO: audit if going through Doorkeeper is worth doing

module Kit::Auth::Actions::Users::UpdateUamForAuthorizationToken
  include Contracts

  #Contract Hash => [Symbol, KeywordArgs[oauth_access_token: Any, errors: Any]]
  def self.call(oauth_access_token:, user_request_metadata:)
    oauth_access_token = oauth_access_token.to_write_record
    oauth_access_token.update({
      last_user_request_metadata: user_request_metadata,
    })

    [:ok]
  end

end