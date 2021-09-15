module Kit::Auth::Actions::RequestMetadata::Create

  #Contract Hash => [Symbol, KeywordArgs[user: Any, errors: Any]]
  def self.call(router_conn:, user: nil)
    ip             = router_conn.client_ip
    user_agent     = router_conn.request[:http][:user_agent] || 'UNKNOWN'
    utm_parameters = router_conn.request[:params].select { |k, _v| k.to_s.start_with?('utm_') }

    request_metadata = Kit::Auth::Models::Write::RequestMetadata.create!({
      user_id:    user&.id,
      ip:         ip,
      user_agent: user_agent,
      utm:        utm_parameters,
    })

    [:ok, request_metadata: request_metadata]
  end

end
