module Kit::Auth::Actions::OauthAccessTokens::UpdateRequestMetadata

  #Contract Hash => [Symbol, KeywordArgs[oauth_access_token: Any, errors: Any]]
  def self.call(oauth_access_token:, request_metadata:)
    oauth_access_token = oauth_access_token.to_write_record
    oauth_access_token.update({
      last_request_metadata: request_metadata,
    })

    [:ok]
  end

end
