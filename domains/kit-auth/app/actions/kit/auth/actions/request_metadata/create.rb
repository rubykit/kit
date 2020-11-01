module Kit::Auth::Actions::RequestMetadata::Create

  #Contract Hash => [Symbol, KeywordArgs[user: Any, errors: Any]]
  def self.call(user:, router_request:)
    ip             = router_request.ip
    user_agent     = router_request.http.user_agent || 'UNKNOWN'
    utm_parameters = router_request.params.select { |k, _v| k.to_s.start_with?('utm_') }

    request_metadata = Kit::Auth::Models::Write::RequestMetadata.create!({
      user_id:    user&.id,
      ip:         ip,
      user_agent: user_agent,
      utm:        utm_parameters,
    })

    [:ok, request_metadata: request_metadata]
  end

end
