module Kit::Auth::Actions::RequestMetadata::Create

  #Contract Hash => [Symbol, KeywordArgs[user: Any, errors: Any]]
  def self.call(router_conn:, user: nil)
    request        = router_conn.request

    ip             = router_conn.client_ip
    user_agent     = request.dig(:http, :user_agent) || 'UNKNOWN'
    session_uid    = request.dig(:http, :session_uid)

    utm_parameters = request[:params].select { |k, _v| k.to_s.start_with?('utm_') }

    request_metadata = Kit::Auth::Models::Write::RequestMetadata.create!({
      user_id: user&.id,
      ip:      ip,
      data:    {
        user_agent:  user_agent.to_s,
        session_uid: session_uid.to_s,
      },
      utm:     utm_parameters,
    })

    [:ok, request_metadata: request_metadata]
  end

end
