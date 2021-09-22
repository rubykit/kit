module Kit::Auth::Actions::Users::IdentifyUserForConn

  # TODO: add contract on router_conn / cookies (based on needed access)
  #Contract Hash => [Symbol, KeywordArgs[user: Any]]
  def self.call(router_conn:, oauth_application:)

    _status, ctx = Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::Users::IdentifyUser,
        self.method(:export_user_to_router_conn),
      ],
      ctx:  {
        router_conn:       router_conn,
        oauth_application: oauth_application,
      },
    )

    if ctx[:errors]
      [:error, user: nil, errors: ctx[:errors]]
    else
      [:ok, ctx.slice(:user, :oauth_access_token)]
    end
  end

  def self.export_user_to_router_conn(router_conn:, oauth_access_token:)
    user  = oauth_access_token&.user

    if user
      [:ok, user: user, oauth_access_token: oauth_access_token]
    else
      [:error, { attribute: :access_token, desc: 'is invalid' }]
    end
  end

end
