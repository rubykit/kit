module Kit::Auth::Actions::AccessTokens::UpdateRequestMetadata

  #Contract Hash => [Symbol, KeywordArgs[access_token: Any, errors: Any]]
  def self.call(access_token:, request_metadata:)
    return [:ok]

    access_token = access_token.to_write_record
    access_token.update(
      last_request_metadata: request_metadata,
    )

    [:ok]
  end

end
