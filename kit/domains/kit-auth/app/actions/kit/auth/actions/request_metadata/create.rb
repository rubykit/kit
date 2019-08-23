module Kit::Auth::Actions::RequestMetadata::Create

  #Contract Hash => [Symbol, KeywordArgs[user: Any, errors: Any]]
  def self.call(user:, request:)
    ip             = request.ip
    user_agent     = request.http.user_agent
    utm_parameters = request.params.select { |k, v| k.to_s.start_with?('utm_') }

    request_metadata = Kit::Auth::Models::Write::RequestMetadata.create!({
      user_id:    user&.id,
      ip:         ip,
      user_agent: user_agent,
      utm:        utm_parameters,
    })

    [:ok, request_metadata: request_metadata]
  end

end