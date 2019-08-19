module Kit::Auth::Actions::UserRequestMetadata::CreateUserRequestMetadata

  #Contract Hash => [Symbol, KeywordArgs[user: Any, errors: Any]]
  def self.call(user:, request:)
    ip             = request.ip
    user_agent     = request.user_agent
    utm_parameters = request.params.to_h.select { |k, v| k.start_with?('utm_') }

    urm = Kit::Auth::Models::Write::UserRequestMetadata.create!({
      user:       user.to_write_record,
      ip:         ip,
      user_agent: user_agent,
      utm:        utm_parameters,
    })

    [:ok, user_request_metadata: urm]
  end

end