module Kit::Auth::Actions::AccessTokens::LinkRequestMetadata

  #Contract Hash => [Symbol, KeywordArgs[access_token: Any, errors: Any]]
  def self.call(access_token:, request_metadata:)
    request_metadata_link = Kit::Domain::Models::Write::RequestMetadataLink
      .find_or_create_by(target_object: access_token, category: 'last')
      .update(request_metadata_id: request_metadata.id)

    [:ok, request_metadata_link: request_metadata_link]
  end

end
